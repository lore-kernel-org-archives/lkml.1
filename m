Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYJGG5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYJGG5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 02:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbYJGG5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 02:57:08 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:35908 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261AbYJGG5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:57:06 -0400
Message-ID: <60844.166.70.238.43.1223360351.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 7 Oct 2008 00:19:11 -0600 (MDT)
Subject: [ANNOUNCE] forenfs: Forensic File System Kernel Patches            
                   2.6.18/2.6.22/2.6.23/2.6.26/2.6.27.5
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patches which involve Linux Kernel Source Code are posted in
compliance with the terms of the GNU Public License.

The Forensic File System is not currently being distributed on Linux in
any commercial product, these patches were generated for internal research
and development purposes only for performance testing of FreeBSD vs.
Linux.

The results of the testing indicate Linux is approximately 8% faster than
FreeBSD on raw I/O, however, the convoluted VFS in Linux is up to 5%
slower than FreeBSD overall on VFS user space operations with forenfs. 
Current Stream to disk rates on Linux are at present 1.3 Gigabytes/second
as opposed to a little over 1.1 Gigabytes/second on FreeBSD.  Linux wins
hands down on raw I/O disk throughput.  FreeBSD on the other hand has a
simple and elegant VFS which is easier to maintain and is significantly
more per formant than the Linux VFS, although it does appear to lack a few
features which Linux supports.

These results were obtained on an unreleased Intel based PCI-Express
system with 16 1TB drives and four high speed PCI-Express 3ware
controllers.

First commercial shipment will occur on FreeBSD due to commercial use and
distribution restrictions imposed by the GPL and various agreements with
commercial customers.   Development on Linux will continue for internal
research and development purposes only in support of performance and
compatibility testing with popular Linux applications which run on
FreeBSD.

These patches do not contain the file system core, only the GPL derivative
works and abstraction layers allowing the cross platform Forensic File
system to load and run on Linux.

Patch series:

ftp://ftp.wolfmountaingroup.org/pub/forenfs/ffs-2.6.18-el5-07-17-08.patch
ftp://ftp.wolfmountaingroup.org/pub/forenfs/ffs-2.6.22.5-suse10.3-05-23-08.patch
ftp://ftp.wolfmountaingroup.org/pub/forenfs/ffs-2.6.23.8-fc8-04-19-08.patch
ftp://ftp.wolfmountaingroup.org/pub/forenfs/ffs-2.6.26-el5-09-02-08.patch
ftp://ftp.wolfmountaingroup.org/pub/forenfs/ffs-2.6.27.5-el5-08-30-08.patch
ftp://ftp.wolfmountaingroup.org/pub/forenfs/forenfs-2.6.18-el5-06-30-08.patch

Jeffrey Vernon Merkey













