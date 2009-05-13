Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZEMCh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZEMCh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZEMCht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:37:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64317 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZEMChs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer;
        b=qEKGCwdnhw74ZnubvIKMlonEejBojo8XAAgehGbMahfyNrXrLlNsRIwRw3YX+fNjh2
         LoiDhHXS+4r0iVdPNeyE9xXls4riBJLCztDtX9oMdChOZ/bsWEbdYT/t1szjJin2VAJR
         ct0N6O088P8Ll7XB+gvXu34OAnJrJlbm38IFk=
Subject: [PATCH]man-pages : section 9  for kernel api description.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: mtk.manpages@gmail.com
Cc: tovalds@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-pBo1xR1OLlBy3sPnxfQ+"
Organization: Private
Date: Wed, 13 May 2009 11:04:28 +0900
Message-Id: <1242180268.31161.24.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pBo1xR1OLlBy3sPnxfQ+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



Dear Michael Kerrisk,

Are you maintainer of man-pages(man-pages-3.XX.tar.gz)?
I am not sure...

I use fedora 9 distribution as Linux based Desktop OS currently. 
I have one proposal about "#> man <linux-kernel-api>" command.
Can you tell me your opinion about below patch?
Thanks reading. 

commit 45e950c98412c002c47254507a199731315c7c2b
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Wed May 13 10:49:47 2009 +0900

    Append Section 9 info of man command.
    
    We view description of the Linux kernel API with man command.
       For example,
       Fedoar9#> yum install kernel-doc*
       Fedora9#> man kobject_rename  or
       Fedora9#> man kthread_create
    
    The man software will display "Section 9"
    like the "KOBJECT_RENAME(9)" info about linux kernel API.
    
       KOBJECT_RENAME(9)                Driver Basics               KOBJECT_RENAME(9)
    
    If most developers all over the world understand "9" meaning
    as linux kernel API, Append "Section 9" info
    in the "man-pages-3.21.Announce" file of man-pages-3.XX.tar.gz .
    ( http://www.kernel.org/pub/linux/docs/manpages/man-pages-3.XX.tar.gz )
    
    	Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

diff --git a/man-pages-3.22.Announce b/man-pages-3.22.Announce
index b52a38f..61f0f64 100644
--- a/man-pages-3.22.Announce
+++ b/man-pages-3.22.Announce
@@ -35,6 +35,7 @@ Here is a breakdown of what this distribution contains:
     Section 6 = games (intro only)
     Section 7 = overviews, conventions, macro packages, etc.
     Section 8 = system administration (intro, plus a few other pages)
+    Section 9 = linux kernel API (e.g., kthread_create, kthread_stop)
 
     This package contains no, or very few, section 1, 6, and 8 man pages
     because these should be distributed with the binaries they are written
diff --git a/man9/intro.9 b/man9/intro.9
new file mode 100644
index 0000000..5440579
--- /dev/null
+++ b/man9/intro.9
@@ -0,0 +1,36 @@
+.\" Copyright (c) 1993 Michael Haardt (michael@moria.de),
+.\"     Fri Apr  2 11:32:09 MET DST 1993
+.\"
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, write to the Free
+.\" Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111,
+.\" USA.
+.\"
+.\" Modified Sat Jul 24 17:19:57 1993 by Rik Faith (faith@cs.unc.edu)
+.\" Modified Wed May 24 10:39:14 2009 by GeunSik Lim (geunsik.lim@samsung.com)
+.TH INTRO 9 2007-10-23 "Linux" "Linux Programmer's Manual"
+.SH NAME
+intro \- Introduction to Linux kernel API
+.SH DESCRIPTION
+Section 9 of the manual describes all the Linux kernel API like kthread_create
+available on the system.
+.SH NOTES
+.SS Authors and Copyright Conditions
+Look at the header of the manual page source for the author(s) and copyright
+conditions.
+Note that these can be different from page to page!


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (ELS - OS Group - S/W Lab - SAIT - SAMSUNG)
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://intomail.dnip.net/invain/me/
-----------------------------------------------

--=-pBo1xR1OLlBy3sPnxfQ+
Content-Disposition: attachment; filename=man-section9-kernel-api.patch
Content-Type: text/x-patch; name=man-section9-kernel-api.patch; charset=euckr
Content-Transfer-Encoding: 7bit

commit 45e950c98412c002c47254507a199731315c7c2b
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Wed May 13 10:49:47 2009 +0900

    Append Section 9 info of man command
    
    We view description of the Linux kernel API with man command.
        For example,
        Fedoar9#> yum install kernel-doc*
        Fedora9#> man kobject_rename  or
        Fedora9#> man kthread_create
    
    The man software will display "Section 9"
    like the "KOBJECT_RENAME(9)" info about linux kernel API.
    
        KOBJECT_RENAME(9)                Driver Basics               KOBJECT_RENAME(9)
    
    If most developers all over the world understand "9" meaning
    as linux kernel API, Append "Section 9" info
    in the "man-pages-3.21.Announce" file of man-pages-3.XX.tar.gz .
    ( http://www.kernel.org/pub/linux/docs/manpages/man-pages-3.XX.tar.gz )
    
    	Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

diff --git a/man-pages-3.22.Announce b/man-pages-3.22.Announce
index b52a38f..61f0f64 100644
--- a/man-pages-3.22.Announce
+++ b/man-pages-3.22.Announce
@@ -35,6 +35,7 @@ Here is a breakdown of what this distribution contains:
     Section 6 = games (intro only)
     Section 7 = overviews, conventions, macro packages, etc.
     Section 8 = system administration (intro, plus a few other pages)
+    Section 9 = linux kernel API (e.g., kthread_create, kthread_stop)
 
     This package contains no, or very few, section 1, 6, and 8 man pages
     because these should be distributed with the binaries they are written
diff --git a/man9/intro.9 b/man9/intro.9
new file mode 100644
index 0000000..5440579
--- /dev/null
+++ b/man9/intro.9
@@ -0,0 +1,36 @@
+.\" Copyright (c) 1993 Michael Haardt (michael@moria.de),
+.\"     Fri Apr  2 11:32:09 MET DST 1993
+.\"
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, write to the Free
+.\" Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111,
+.\" USA.
+.\"
+.\" Modified Sat Jul 24 17:19:57 1993 by Rik Faith (faith@cs.unc.edu)
+.\" Modified Wed May 24 10:39:14 2009 by GeunSik Lim (geunsik.lim@samsung.com)
+.TH INTRO 9 2007-10-23 "Linux" "Linux Programmer's Manual"
+.SH NAME
+intro \- Introduction to Linux kernel API
+.SH DESCRIPTION
+Section 9 of the manual describes all the Linux kernel API like kthread_create
+available on the system.
+.SH NOTES
+.SS Authors and Copyright Conditions
+Look at the header of the manual page source for the author(s) and copyright
+conditions.
+Note that these can be different from page to page!

--=-pBo1xR1OLlBy3sPnxfQ+--

