Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbXEXKv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbXEXKv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbXEXKvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:51:48 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53946 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbXEXKvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:51:47 -0400
Date: Thu, 24 May 2007 12:50:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
In-Reply-To: <46556CB2.8010709@gmx.de>
Message-ID: <Pine.LNX.4.61.0705241246180.31549@yvahk01.tjqt.qr>
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>
 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc>
 <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc>
 <4655676A.1000102@gmx.de> <Pine.LNX.4.61.0705241224510.31549@yvahk01.tjqt.qr>
 <46556CB2.8010709@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 1.5 points, 6.0 required
	1.5 MAILTO_TO_SPAM_ADDR    URI: Includes a link to a likely spammer email
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24 2007 12:45, Lars K.W. Gohlke wrote:

>Date: Thu, 24 May 2007 12:45:06 +0200
>From: Lars K.W. Gohlke <lkwg82@gmx.de>
>To: Jan Engelhardt <jengelh@linux01.gwdg.de>
>Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
>Subject: Re: How to access correctly serial port inside module?
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Jan Engelhardt schrieb:
>> On May 24 2007 12:22, Lars K.W. Gohlke wrote:
>> > ok, I have read everything and also have read the chapters about
>> > tty_drivers. However I'm not really understand, how to ... .
>> > 
>> > I will summarize the concrete scenario, which will lead to the
>> > understanding and further solution of deadling with serial driver.
>> > 
>> > [scenario]
>> > 
>> > 1. in userspace I'm doing: > date > /dev/ttyS0
>> > 2. in kernelspace I want to print out this date.
>> > 
>> > [/scenario]
>> > 
>> > I'm really new to kernel coding, that's why I maybe understand some
>> > functions not the proper way.
>> > 
>> > I'm a bit confused.
>> 
>> So am I. Usually, you connect two different machines with a serial cable.
>> (Leaving out the special case of connecting ttyS0-ttyS1 on the same
>> machine.)
>> 
>> This poses the first question: whose kernelspace? the sender or
>> the receiver side? And by "this date" do you perhaps mean
>> "whatever was sent", or specifically a date? And print to _where_?
>> 
>> Up to now, it looks like you want to do "cat </dev/ttyS0" in-kernel.
>> 
>> 
>> Jan
>
> date is an example
>
> and you got it, I want to do "cat </dev/ttyS0" in-kernel.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959
>
> iD8DBQFGVWy0AAomYJ1taN8RAu7/AJ9+1irJURFy5KFy/wzHqSXXD5sRgACfSi49
> ec5AnOQoTz2nCt//siaiTNs=
> =uj4G
> -----END PGP SIGNATURE-----
>

	Jan
-- 
