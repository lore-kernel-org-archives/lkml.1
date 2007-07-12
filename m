Return-Path: <linux-kernel-owner+w=401wt.eu-S935040AbXGLB6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040AbXGLB6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXGLB60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:58:26 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:45807 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762712AbXGLB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:58:25 -0400
Date: Thu, 12 Jul 2007 11:58:24 +1000
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kai@germaschewski.name
Subject: Re: [PATCH] mkmakefile: include ARCH on O= builds
Message-ID: <20070712015823.GM10345@bakeyournoodle.com>
References: <Pine.LNX.4.58.0707120331530.28774@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707120331530.28774@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 03:40:04AM +0200, Bodo Eggert wrote:
> If you build using O=builddir ARCH=bar, you'll currently need to supply
> ARCH= on builds from the builddir, too. With this patch, the generated
> Makefile will do that instead.

<snip>

> diff -X dontdiff -pruN linux-2.6.22/scripts/mkmakefile linux-2.6.22.changed/scripts/mkmakefile
> --- linux-2.6.22/scripts/mkmakefile	2006-11-29 22:57:37.000000000 +0100
> +++ linux-2.6.22.changed/scripts/mkmakefile	2007-07-12 03:03:49.000000000 +0200
> @@ -8,6 +8,7 @@
>  # $2 - Output directory
>  # $3 - version
>  # $4 - patchlevel
> +# $5 - patchlevel

Really?  I suspect you wanted
  +# $5 - architecture

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

