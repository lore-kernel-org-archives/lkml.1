Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYE3R3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYE3R3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYE3R3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:29:03 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:41070 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbYE3R3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:29:01 -0400
Message-ID: <4840395A.108@tampabay.rr.com>
Date: Fri, 30 May 2008 13:28:58 -0400
From: Marco <marco@tampabay.rr.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: New Kernel headers vs old Kernel headers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a69c0ff6d203d3d794f5150ab1c16ac08868399773331e30fb1f01059939acb910029d55878c30ec350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.91.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I've come across a little discrepancy between the glibc docs and linux
kernel docs when I was trying to figure out what kernel headers I should
being using for my cross compiling.  The docs seem to say almost exactly
the opposite thing.

For a quick summary: linux docs(headers_install.txt) seem to indicate,
running glibc compiled against new kernel headers, on an older kernel
will possibly cause problems.  Where as glib docs(FAQ) indicate glibc
compiled against new kernel headers, will run fine on an older kernel.

Can someone shed some light on this (i.e. which is right)?

Thank you in advance

Marco Fonseca

(p.s. I've included the sections from both docs below for easy reference)


In linux-2.6.24/Documentation/make/headers_install.txt:
...
Kernel headers are backwards compatible, but not forwards compatible.  This
means that a program built against a C library using older kernel headers
should run on a newer kernel (although it may not have access to new
features), but a program built against newer kernel headers may not work
on an
older kernel.
...
------------------
In glibc-2.7/FAQ
...
1.8.    What version of the Linux kernel headers should be used?

{AJ,UD} The headers from the most recent Linux kernel should be used.  The
headers used while compiling the GNU C library and the kernel binary used
when using the library do not need to match.  The GNU C library runs without
problems on kernels that are older than the kernel headers used.  The other
way round (compiling the GNU C library with old kernel headers and running
on a recent kernel) does not necessarily work.  For example you can't use
new kernel features if you used old kernel headers to compile the GNU C
library.
...

