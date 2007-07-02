Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbXGBJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbXGBJWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXGBJWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:22:13 -0400
Received: from mailhost.terra.es ([213.4.149.12]:29739 "EHLO
	csmtpout2.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751354AbXGBJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:22:12 -0400
Subject: ppdev - libieee1284.so  conflicts with 2.6.21
From: Juan Antonio Martinez <jonsito@teleline.es>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 02 Jul 2007 11:22:09 +0200
Message-Id: <1183368129.4967.1.camel@drake.micasa.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've reported this error to Fedora Bugzilla:

http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246406

In sort: to use libieee1284 I need to disable ppdev usage with
kernel 2.6.21. Kernel 2.6.20 works fine

[root@drake char]# uname -a
Linux drake.micasa.es 2.6.21-1.3228.fc7 #1 SMP Tue Jun 12 15:37:31 EDT
2007 i686 athlon i386 GNU/Linux

By doing "echo disallow method ppdev > /etc/ieee1284.conf" everything
works fine on both kernels

Seems affect several distributions, not Fedora specific:
http://bugs.archlinux.org/task/7438
http://sourceforge.net/tracker/index.php?func=detail&aid=1739643&group_id=29314&atid=395778
http://www.digipedia.pl/man/libieee1284.3.html

Not sure if a kernel bug or a library one, so my apologizes if
this is not the propper list

Juan Antonio


