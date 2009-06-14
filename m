Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZFNJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZFNJHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZFNJH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:07:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZFNJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:07:28 -0400
Subject: Re: [PATCH 04/14] Pramfs: Mounting as root filesystem
From: David Woodhouse <dwmw2@infradead.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
In-Reply-To: <4A34B2FD.20701@gmail.com>
References: <4A33A7D7.3040008@gmail.com> <200906140104.43463.arnd@arndb.de>
	 <4A34B2FD.20701@gmail.com>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 10:07:25 +0100
Message-Id: <1244970445.3468.2732.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 10:21 +0200, Marco wrote:
> 
> Mmm...MEM_MAJOR and RAMDISK_MAJOR have the same value and pramfs works
> in memory. We could simply use /dev/null (there was an error in the
> submitted kconfig description, my intention was to use /dev/mem). In
> that case I can use UNNAMED_MAJOR. PRAMFS root option is not enabled
> if it's already enabled the NFS one. What do you think?

Why use a major number at all? See how we handle mtd and ubi devices in
prepare_namespace() -- can't you do something similar?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

