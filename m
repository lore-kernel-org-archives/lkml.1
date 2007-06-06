Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbXFFPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbXFFPpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764872AbXFFPpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:45:44 -0400
Received: from waldorf.cs.uni-dortmund.de ([129.217.4.42]:35201 "EHLO
	waldorf.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758901AbXFFPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:45:43 -0400
X-Greylist: delayed 2407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 11:45:43 EDT
Date: Wed, 6 Jun 2007 17:05:34 +0200
From: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
To: linux-kernel@vger.kernel.org
Subject: Size of kernel modules
Message-Id: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
Organization: Universitaet Dortmund
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; sparc-sun-solaris2.8)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a machine here which I installed with Ubuntu 7.04. Immediately
after the installation had been finished, I installed the Ubuntu package
which contains the Ubuntu-modified sources of the linux kernel. I
extracted the resulting tar.bz2-file, copied the configuration of the
currently running kernel to .config and created a file localversion-irb
which contains the line "-irb" and then called "make menuconfig". In the
menu, I changed the CPU type from 586 to Pentium Pro and entered "-686"
as the localversion. Finally, I used the Ubuntu tool make-kpkg with
option "--initrd" to create a new kernel. The option "--initrd" causes
the installation scripts of the kernel package to automatically create
an initial ramdisk for the kernel.

After the new kernel package had been created, I installed it. After
that, I looked into the directory /boot and was very surprised: The
initial ramdisk of the new kernel was much larger than the initrd of the
old kernel. To find out the cause for this, I investigated how
directories /lib/modules/$old and /lib/modules/$new differ. I found out
that the filenames are the same, but the size of the files differs very
much. I found a module file in the new directory that was almost five
times as large as the file with the same name in the old directory.

So, my question is the follwing: Is it an expected feature that the file
sizes of modules grow so much only because of a different cpu type and a
different localversion, or is there probably a bug in my build tools?

Regards
  Christoph
