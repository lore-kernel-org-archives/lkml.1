Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYD0RAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYD0RAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYD0RA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:00:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51910 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752530AbYD0RAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:00:25 -0400
Date: Sun, 27 Apr 2008 17:50:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: monstr@seznam.cz
Cc: microblaze-uclinux@itee.uq.edu.au, Matthew Wilcox <matthew@wil.cx>,
       Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
Message-ID: <20080427175049.765766c8@core>
In-Reply-To: <4814A153.3040600@seznam.cz>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
	<200804221515.28075.arnd@arndb.de>
	<480FA729.3000406@seznam.cz>
	<200804241311.09881.arnd@arndb.de>
	<4810D4A4.7050900@seznam.cz>
	<4811A623.80104@itee.uq.edu.au>
	<20080425100614.GB14990@parisc-linux.org>
	<4813DF3E.6080800@itee.uq.edu.au>
	<4814A153.3040600@seznam.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is two opinions:
> * One is take syscall table with old syscalls for backward compatibility.
> As John W wrote. Microblaze has history around 4 years and 2.6 kernel almost 2
> years.

I would keep the old syscall table. Otherwise you end up with two
differing microblaze setups and people will get binaries, libraries and
compilers muddled up for years to come which will be nothing but pain for
eveyone.

Alan
