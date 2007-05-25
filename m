Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbXEYACJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbXEYACJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXEYAB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:01:57 -0400
Received: from nicole.bmts.com ([216.183.128.225]:46093 "EHLO nicole.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXEYAB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:01:56 -0400
Date: Thu, 24 May 2007 20:01:46 -0400
From: Mike Houston <mikeserv@BMTS.COM>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Houston <mikeserv@BMTS.COM>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sky2/pci issues on Gigabyte
Message-Id: <20070524200146.a9e4906c.mikeserv@bmts.com>
In-Reply-To: <20070524160440.63667048@freepuppy>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
	<20070522181444.ad932718.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
	<20070523133909.a3ec171a.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705231044160.3890@woody.linux-foundation.org>
	<20070524142644.837a26ed.mikeserv@bmts.com>
	<20070524150845.07d0608f@freepuppy>
	<alpine.LFD.0.98.0705241524350.26602@woody.linux-foundation.org>
	<20070524160440.63667048@freepuppy>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 16:04:40 -0700
Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > 	-00: 86 80 47 28 07 00 10 00 02 00 04 06 08 00 81 00
> > 	+00: 86 80 47 28 07 04 10 00 02 00 04 06 08 00 81 00
>                              ^--- INTX disable bit
> 	Vista isn't enabling MSI, Linux is.
> 	Try "nomsi"?

I had noticed that Vista wasn't using MSI for any devices and I
tried booting with pci=nomsi in addition to building the kernel
without MSI enabled (just in case there might somehow be a
difference). I see I should have mentioned it, but it had no effect
on the problem. The device gets IRQ 16 in Linux without MSI and it
still croaks with the same messages.

Mike Houston
