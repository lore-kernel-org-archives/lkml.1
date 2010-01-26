Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214Ab0AZCCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0AZCCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864Ab0AZCCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:02:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61678 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab0AZCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=X+WVURifjgCmySqQwkinsCveqReGsPbWvowcLlQCdb0Vaio0xA4eWUi/n76MOhzWuG
         hsnABTDLF81rFOTByeJyQzn/XfhX6qeEjjG7P6CiQDK80+Rs0xLADA11IL7/CddS3i8M
         hPgloR4bQwIENsrsQezGFaMUH3nfJEbNty0DI=
Date: Mon, 25 Jan 2010 20:02:03 -0600
From: William Hubbs <w.d.hubbs@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: gregkh@suse.de, Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Chris Brannon <cmbrannon79@gmail.com>, Kirk Reiser <kirk@reisers.ca>
Subject: request for assistance:  accessing ttys from kernel space
Message-ID: <20100126020203.GA23551@linux1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am the lead developer for gentoo linux's accessibility team[1], and I
am on the development team for the speakup screen reader [2].

I received these addresses from Samuel, and Chris and Kirk are the other
developers on the speakup team.

Currently, speakup is using direct hardware access to communicate with
serial ports.  Doing so, however, has limitations since we are hard
coding port addresses and IRQ numbers.  For example, we have a user
right now who is wanting to use a PCI Express serial card for his
synthesizer, but the port and IRQ are not standard, so speakup is unable
to use it.  He says that the kernel does recognize the card however.

What I would like to discuss is how we can access ttys from kernel
space.  If we could do this, it would definitely make things much easier
for us in speakup.

For reference, our git repository is at
http://linux-speakup.org/speakup.git.  We are looking to write another
.c file similar to serialio.c but using ttys or some other way to access
the serial ports which works better than hard coading ports and IRQs.

We found another example of attempting this on the web [3], but this
doesn't work any longer according to the thread.

We need to be able to access the ttys as early as possible in the boot
sequence.  Any help, suggestions, or guidance you could give us would be
greatly appreciated.

Thanks much,

William

[1] http://www.gentoo.org/proj/en/desktop/accessibility
[2] http://linux-speakup.org
[3]
http://www.linuxquestions.org/questions/programming-9/accessing-tty-in-kernel-space-596538/
