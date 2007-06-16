Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbXFQOCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbXFQOCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXFQOCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:02:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:53174 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753292AbXFQOCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:02:31 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/Gc4t5GJfGz8UBnAZcmr6rs1D0BKtsdp14CP0Idc
	wfvlhyyT35un0Z
Message-ID: <4673D832.8060009@gmx.net>
Date: Sat, 16 Jun 2007 14:31:46 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.57 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I just released man-pages-2.57.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Various things remain to be fixed in man-pages.  A few of the outstanding
FIXME points from section 2 are listed below.  Any assistance with these
points would be most welcome.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

==========
./man2/ioperm.2
     FIXME is the following ("Only the first 0x3ff I/O ports can be
     specified in this manner") still true?  Looking at changes in
     include/asm-i386/processor.h between 2.4 and 2.6 suggests
     that the limit is different in 2.6.

==========
./man2/mprotect.2
     FIXME
     Document PROT_GROWSUP and PROT_GROWSDOWN

==========
./man2/nfsservctl.2
     FIXME The description of nfsservctl() on this page
     is woefully thin.

==========
./man2/shmop.2
     FIXME A good explanation of the rationale for the existence
     of SHMLBA would be useful here

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.


