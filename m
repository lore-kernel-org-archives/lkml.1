Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbXDWXdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbXDWXdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXDWXdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:33:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbXDWXdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:33:21 -0400
Date: Mon, 23 Apr 2007 16:33:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Ranon <mranon@javadevices.com>
Cc: linux maillist <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
Message-Id: <20070423163316.d197bf16.akpm@linux-foundation.org>
In-Reply-To: <875184.9239.qm@web88101.mail.re2.yahoo.com>
References: <875184.9239.qm@web88101.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 14:31:39 -0700 (PDT)
Matt Ranon <mranon@javadevices.com> wrote:
>

(text reformatted to less than 80 cols.  Please, we'll get along a lot
better if you don't send 1000-column emails)

> The Jem team is pleased to announce the release of Kcli, an in-kernel
> command line interface.  Kcli is intended for a special class of embedded
> Linux applications.  The Linux kernel has become the defacto standard OS
> for embedded applications.  This means that Linux is getting bent in some
> ways that may appear strange to some.  One of these ways, is embedded
> applications that do not use user space.  User space consists of a
> statically linked, one line program, that simply sleeps forever,
> transforming Linux into a classical embedded RTOS.  VxWorks developers will
> understand what we are talking about, and they may recall how much they
> depend on the VxWorks shell.  Kcli attempts to meet the need for a shell
> for this class of embedded Linux applications.  

Alas, we are not vxworks developers, and probably most of us know zero
about the use-cases for this feature, why embedded systems find it
valuable, etc.

So it's up to you to tell us all this.

> Kcli provides a command line environment that runs in the kernel, and that
> can be extended with custom commands registered by other kernel modules. 
> We have found Kcli invaluable for our development, and we are releasing the
> patch, in case others find it useful.
> 
> Kcli is directly derived from libcli written by David Parrish and Brendan
> O'Dea, and the regular expression support is directly derived from diet
> libc written by Felix von Leitner.
> 
> The Jem team fully understands that this kind of patch may not be
> appropriate for inclusion in the mainline kernel code.  We have no
> expectation that it will be, and we leave that decision fully in the hands
> of those responsible.

We don't have enough information to make that call.

>  Nonetheless, we feel that others may find it useful,
> and we will also appreciate any appropriate feedback from the community.
> 
> Kcli is standalone, and modifies no kernel files, except for the Kconfig
> and Makefile modifications required to wire it into the configuration and
> build.

The obvious question is: what's _wrong_ with doing all this in some
cut-down userspace environment like busybox?  Why is this stuff better?

Obviously some embedded developers have considered that option and
have rejected it.  But we do need to be told, at length, why that
decision was made.

