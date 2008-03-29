Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYC2Aor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYC2Aor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYC2Aoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:44:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYC2Aoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:44:38 -0400
Date: Sat, 29 Mar 2008 01:44:37 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "John T." <j.thomast@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
In-Reply-To: <47ED8C13.5060509@zytor.com>
Message-ID: <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr>
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-03-29 01:23, H. Peter Anvin wrote:
>>  And while we are at it, I'd suggest a whole new set of escape
>>  codes, the current sequences are particularly... bad for
>>  stream synchronization. Right now one has to parse strings for
>>  end-of-escape.. which is awkward. I'd just be able to
>>  strchr(s, '^]') for example and know when the escape code
>>  ends. (Compat should of course be honored where necessary.)
>
> I think it would be a major lose to move away from ISO 6429 format; the format 
> is self-terminating and really isn't all that complex.

What do you mean by self-terminating? There is no easy
synchronization like in UTF-8, given you are anywhere inside
a text stream, how do you know (a) you are already in an
escape sequence and (b) how to figure out the rebegin of
normal text.
