Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZGTUNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZGTUNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZGTUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:13:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZGTUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:13:19 -0400
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
 kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090720200522.GA6854@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org>
	 <1248086059.15751.8405.camel@twins>
	 <20090720115134.GA6517@merkur.ravnborg.org>
	 <1248091243.15751.8550.camel@twins>
	 <20090720171200.GA6730@merkur.ravnborg.org>
	 <20090720200522.GA6854@merkur.ravnborg.org>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 22:13:17 +0200
Message-Id: <1248120797.23509.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 22:05 +0200, Sam Ravnborg wrote:

> From 27d34661aed0cd3fbf469b8efb24accaf83c1987 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 20 Jul 2009 21:37:11 +0200
> Subject: [PATCH] kbuild: Use INSTALLKERNEL to select customized installkernel script
> 
> Replace the use of CROSS_COMPILE to select a customized
> installkernel script with the possibility to set INSTALLKERNEL
> to select a custom installkernel script when running make:
> 
>     make INSTALLKERNEL=arm-installkernel install
> 
> With this patch we are now more consistent across
> different architectures - they did not all support use
> of CROSS_COMPILE.
> 
> The use of CROSS_COMPILE was a hack as this really belongs
> to gcc/binutils and the installkernel script does not change
> just because we change toolchain.
> 
> The use of CROSS_COMPILE caused troubles with an upcoming patch
> that saves CROSS_COMPILE when a kernel is built -
> it would no longer be installable.
> [Thanks to Peter for this hint]
> 
> This patch undos what Ian did in commit:
> 
>   0f8e2d62fa04441cd12c08ce521e84e5bd3f8a46
>   ("use ${CROSS_COMPILE}installkernel in arch/*/boot/install.sh")
> 
> The patch has been lightly tested on x86 - but all changes
> looks obvious.

Acked-by: Peter Zijlstra <peterz@infradead.org>

Looks good to me, thanks sam!

