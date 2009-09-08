Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZIHQyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZIHQyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZIHQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:54:40 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:58396 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZIHQyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:54:39 -0400
X-IronPort-AV: E=Sophos;i="4.44,353,1249272000"; 
   d="scan'208";a="4068110"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: asm-generic update candidates?
Date: Tue, 8 Sep 2009 12:58:50 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200909031729.52538.rgetz@blackfin.uclinux.org> <200909041539.28384.rgetz@blackfin.uclinux.org> <200909081455.45576.arnd@arndb.de>
In-Reply-To: <200909081455.45576.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200909081258.50345.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 08 Sep 2009 16:54:41.0473 (UTC) FILETIME=[0F1C4B10:01CA30A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 8 Sep 2009 08:55, Arnd Bergmann pondered:
> On Friday 04 September 2009, Robin Getz wrote:
> > I also noticed in Linus's latest (last commit 
> > 37d0892c5a94e208cf863e3b7bac014edee4346d):
> > 
> > cat arch/microblaze/include/asm/ipc.h
> > #include <asm-generic/ipc.h>
> > 
> > but: ls include/asm-generic/ipc.h
> > ls: cannot access include/asm-generic/ipc.h: No such file or directory
> 
> Adrian Bunk killed that file in asm/ back in 2007, he probably crossed
> patches with the microblaze architecture.

Ok - that got me doing a quick look:

asm-generic/compat_signal.h doesn't exist?
arch/parisc/include/asm/compat_signal.h:#include <asm-generic/compat_signal.h>

asm-generic/cpumask.h doesn't exist?
arch/frv/include/asm/cpumask.h:#include <asm-generic/cpumask.h>
arch/xtensa/include/asm/cpumask.h:#include <asm-generic/cpumask.h>

asm-generic/ipc.h doesn't exist?
arch/microblaze/include/asm/ipc.h:#include <asm-generic/ipc.h>
arch/mn10300/include/asm/ipc.h:#include <asm-generic/ipc.h>

asm-generic/rmap.h doesn't exist?
arch/xtensa/include/asm/rmap.h:#include <asm-generic/rmap.h>


Maybe checkpatch (or something else?) needs something to make sure all 
referenced files are actually in the tree or in the patch?
