Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYDFKOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYDFKOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 06:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYDFKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 06:14:12 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:36449 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbYDFKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 06:14:12 -0400
Message-ID: <47F8A26E.3080606@davidnewall.com>
Date: Sun, 06 Apr 2008 19:44:06 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Marko Macek <Marko.Macek@gmx.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       "John T." <j.thomast@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <47F88DDB.30409@gmx.net>
In-Reply-To: <47F88DDB.30409@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marko Macek wrote:
> H. Peter Anvin wrote:
>
>> One would also like to distinguish, say, Backspace from Ctrl-H.  This
>> is trickier, because the termios settings don't permit compound
>> keys.  The most obvious way to deal with that is an escape code for
>> Ctrl-H, but that has the risk of breaking a lot of other things.
>
> Backspace is not a problem, since it generates ^? (DEL/127) on Linux
> since the early days.

And yet, Ctrl/H *is* backspace.  Look it up in any ASCII chart.  Let's
not make a virtue out of ignoring or breaking standards.
