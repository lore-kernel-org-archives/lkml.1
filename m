Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYC2AYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYC2AYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYC2AXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:23:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbYC2AXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:23:52 -0400
Message-ID: <47ED8C13.5060509@zytor.com>
Date: Fri, 28 Mar 2008 17:23:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "John T." <j.thomast@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> And while we are at it, I'd suggest a whole new set of escape
> codes, the current sequences are particularly... bad for
> stream synchronization. Right now one has to parse strings for
> end-of-escape.. which is awkward. I'd just be able to
> strchr(s, '^]') for example and know when the escape code
> ends. (Compat should of course be honored where necessary.)

I think it would be a major lose to move away from ISO 6429 format; the 
format is self-terminating and really isn't all that complex.

	-hpa
