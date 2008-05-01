Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYEAA7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYEAA7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYEAA6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:58:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:10269 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAA6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XdG8Y2MPY6pm5KnSC0YbCqClULmS+z94yrulFrT565MIoZV6mU0pt8ZUHS11Naapg9ShG5l0rJFd9GPEpdsgmk1gXz6Q/d2GUsiawcuCmP+bzLyMTzrHuVNkrxm3VGnS3Xx9CL9gdPg1DXBOhTLkH4Qp0PGDNL7Z0A5Lxtoq6oM=
Subject: Strange problems building 2.6.2[45] for Winchip2A under Ubuntu
From: David Hagood <david.hagood@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 30 Apr 2008 19:58:45 -0500
Message-Id: <1209603525.8100.43.camel@surfer>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an old laptop I'm trying to resurrect, and am having a strange
problem:

If I run the kernels supplied by Xubuntu, all is well - no strange
behavior (as in, none of the stuff I am about to describe happens).

If I build my own kernel (as I am trying to strip out unneeded stuff
this machine does not and never will have like AGP and Bluetooth), weird
things happen:
  For 2.6.25, I cannot read or write to /proc/mtrr - I get an I/O error
(the file exists within proc)
  Starting klogd hangs for about 2 minutes - looking at the system
during this time shows a "dd if=/proc/kmsg of=/var/log/kmsg" process
hanging. Attempting this by hand shows dd hangs (as does a
"cat /proc/kmsg").

Other than this, the system runs (networking comes up, X comes up
(eventually).

I've tried just building with the kernel configuration Xubuntu uses to
the same results.

I would think that the fact that the Xubuntu supplies kernels work would
tend to exonerate the hardware, that building with the Xubuntu supplied
configuration would tend to exonerate the configuration, but that leaves
me stumped - either my version of GCC is screwy, or my build process is
bad, or ???

(builds are done on my Athlon Ubuntu machine ( GCC version 4.2.3 (Ubuntu
4.2.3-2ubuntu7)) via the standard "make gconfig; make" process on a
tarball pulled fresh from kernel.org, which is then NFS mounted by the
target, a final "make modules_install install" executed, and the initrd
created on the target).


