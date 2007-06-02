Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbXFBJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbXFBJlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 05:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbXFBJlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 05:41:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36783 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXFBJlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 05:41:10 -0400
X-Originating-Ip: 72.143.65.211
Date: Sat, 2 Jun 2007 05:39:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: umesh@websurfer.com.np
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel message
In-Reply-To: <2631.63.219.2.2.1180775978.squirrel@mail.websurfer.com.np>
Message-ID: <Pine.LNX.4.64.0706020538490.7922@localhost.localdomain>
References: <2631.63.219.2.2.1180775978.squirrel@mail.websurfer.com.np>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, umesh@websurfer.com.np wrote:

> Can anyone send me the documentation about dmesg message that how
> can we understand by it. I am searching good document which can
> explain each and every line of dmesg.
>
> umesh

  this is really more of a kernel newbie question that belongs on the
newbie list but, if you really want to know the meaning of each line,
you might want to trace the code from kernel startup to see when each
of those lines is printed to see what they represent.

  starting in init/main.c, find the routine "start_kernel" around line
500 and several lines in, you'll see:

...
printk(KERN_NOTICE);
printk(linux_banner);
...

(why these two printk's are broken over two lines is a mystery but ...
whatever.)

  then if you go to init/version.c, you can verify that linux_banner
does indeed represent the normal first line in /var/log/dmesg, such
as:

Linux version 2.6.20-1.2948.fc6
(brewbuilder@hs20-bc1-7.build.redhat.com) (gcc version 4.1.1 20070105
(Red Hat 4.1.1-51)) #1 SMP Fri Apr 27 19:48:40 EDT 2007

  at that point, start following the code to see where each line in
dmesg comes from.

rday

p.s.  please use a better subject line than just "Kernel message".
that doesn't tell anyone what you're actually asking about.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
