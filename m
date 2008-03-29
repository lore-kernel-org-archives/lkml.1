Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYC2GdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYC2GdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 02:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYC2GdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 02:33:11 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:35001 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbYC2GdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 02:33:11 -0400
Message-ID: <47EDE2A4.8080702@davidnewall.com>
Date: Sat, 29 Mar 2008 17:03:08 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com> <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> What do you mean by self-terminating? There is no easy
> synchronization like in UTF-8, given you are anywhere inside
> a text stream, how do you know (a) you are already in an
> escape sequence and (b) how to figure out the rebegin of
> normal text.

It's not very useful being able to tell you are inside a escape sequence
unless you see that sequence from the start.  You do need the complete
sequence to make sense of it.
