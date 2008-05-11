Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbYEKWns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbYEKWns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYEKWnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:43:41 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:36409 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYEKWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:43:40 -0400
X-ClientAddr: 220.233.82.121
Subject: Re: Microblaze toolchain - libc
From: John Williams <john.williams@petalogix.com>
To: monstr@seznam.cz
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, microblaze-uclinux@itee.uq.edu.au,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <4826FD34.5030009@seznam.cz>
References: <4826FD34.5030009@seznam.cz>
Content-Type: text/plain
Organization: PetaLogix
Date: Mon, 12 May 2008 08:43:08 +1000
Message-Id: <1210545788.5798.273.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Sun, 2008-05-11 at 16:05 +0200, Michal Simek wrote:


> is it any movement in libc?
> I would like clear code around syscalls.

I can't see anything radical happening with glibc / uClibc in the short
term.  My suggestion is you make sure the kernel builds with current
toolchain.  

I'm not personally concerned about minor bloat of adding syscalls like
openat() that are not currently used - 1 or 2 K for extra entries in
syscall table, and a few hundred bytes per sys_wrapper really is not on
the radar if glibc is considered a sensible library for Microblaze +
MMU!

Regards,

John


