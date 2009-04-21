Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZDUUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZDUUOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZDUUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:14:23 -0400
Received: from nn7.de ([85.214.94.156]:37541 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZDUUOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:14:22 -0400
Subject: Re: git-current build failure: In function `intel_opregion_init':
 undefined reference to `acpi_video_register'
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1240082271.5816.3.camel@localhost>
References: <1240082271.5816.3.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Apr 2009 22:14:15 +0200
Message-Id: <1240344856.5114.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This build failure is still there in
a939b96cccdb65df80a52447ec8e4a6d79c56dbb

Soeren

On Sat, 2009-04-18 at 21:17 +0200, Soeren Sonnenburg wrote:
> Dear all,
> 
> I am seeing this with 2.6.30+ 
> git aefe6475720bd5eb8aacbc881488f3aa65618562
> 
> $ make ARCH=i386 -j 4
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `intel_opregion_init':
> (.text+0xcf058): undefined reference to `acpi_video_register'
> make: *** [.tmp_vmlinux1] Error 1
> 
> config is attached.
> 
> Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
