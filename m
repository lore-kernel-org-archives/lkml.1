Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbZFNPQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbZFNPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZFNPQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:16:18 -0400
Received: from aun.it.uu.se ([130.238.12.36]:45924 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZFNPQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:16:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18997.5184.484019.744195@pilspetsen.it.uu.se>
Date: Sun, 14 Jun 2009 17:16:16 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: crypt issue with 2.6.30/gcc 4.4.0?
In-Reply-To: <4A34FD06.2020204@xs4all.nl>
References: <4A34FD06.2020204@xs4all.nl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel writes:
 > Hello,
 > 
 > I am having trouble decrypting my dm-crypted disks with 2.6.30. 2.6.29.4
 > works fine with the same encrypted disks.
 > I've been upgrading to Fedora 11 in the past few days so now GCC 4.4.0
 > is the compiler, that may (also) be a factor.
 > 
 > On 2.6.92.4 I see the encryption password prompt being buried by a lot
 > of USB-messages from connected gear. I can 'blindly' type my password
 > and asterisks appear for each letter. At the end of the password I press
 > Enter; a complaint about the partition table for md1 is displayed and
 > booting continues.
 > With 2.6.30 I see the Password prompt being repeated, after all the USB
 > messages, as soon as I press the first letter of the password. Each time
 > the password is entered it is not accepted and a new Password: prompt is
 > printed up to a total of three tries.
 > 
 > For all of these boots into 2.6.29.4 or 2.6.30 the userland etc is the
 > same (Fedora 11), it is just that 2.6.29.4 was built while running
 > Fedora 10 and 2.6.30 is now built with the tools in 2.6.30.
 > I did boot into 2.6.30 (built while running Fedora 10) successfully
 > once, right after the upgrade to Fedora 11. Later I made small changes
 > to the kernel config and rebuilt the kernel and this made the encryption
 > password fail. A `make clean` and rebuild does not fix the issue
 > 
 > How can I find out what's the cause for the password issue?

Instead of changing two variables at once (kernel version AND gcc version)
you keep one constant and vary the other.

IOW, rebuild 2.6.29.4 with gcc-4.4 and test.
Then rebuild 2.6.30 with gcc-4.3 or older and test.
