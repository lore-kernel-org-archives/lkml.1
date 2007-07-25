Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbXGYNQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbXGYNQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765114AbXGYNQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:16:15 -0400
Received: from lucidpixels.com ([75.144.35.66]:56239 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765062AbXGYNQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:16:14 -0400
Date: Wed, 25 Jul 2007 09:16:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Re: Cannot write file larger than 2TB on x86_64?
In-Reply-To: <Pine.LNX.4.64.0707250914310.16609@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0707250916010.16609@p34.internal.lan>
References: <Pine.LNX.4.64.0707250914310.16609@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erm, unless this is an EXT3 limitation--oops..

On Wed, 25 Jul 2007, Justin Piszcz wrote:

> The kernel is 2.6.9-42.ELsmp on RHEL4 x86_64.
>
> servername$ dd if=/dev/zero of=4.8tb_file bs=1M count=4800000
> File size limit exceeded
> servername$ (stopped at 2TB)
>
> The 64bit should not need the option obviously, because it is 64bit, is this 
> a b
> ug in the kernel?
>
> For 32bit:
> .config - Linux Kernel v2.6.22 Configuration
> ..............................................................................
>  ..................... Support for Large Single Files ......................
>  . CONFIG_LSF:                                                             .
>  .                                                                         .
>  . Say Y here if you want to be able to handle very large files (bigger    .
>  . than 2TB), otherwise say N.                                             .
>  .                                                                         .
>  . If unsure, say Y.                                                       .
>  .
>
> For 64bit:
> .config - Linux Kernel v2.6.22 Configuration
> ..............................................................................
>  ............................... Block layer ...............................
>  .  Arrow keys navigate the menu.  <Enter> selects submenus --->.          .
>  .  Highlighted letters are hotkeys.  Pressing <Y> includes, <N> excludes, .
>  .  <M> modularizes features.  Press <Esc><Esc> to exit, <?> for Help, </> .
>  .  for Search.  Legend: [*] built-in  [ ] excluded  <M> module  < >       .
>  . ....................................................................... .
>  . .    --- Enable the block layer                                       . .
>  . .    [ ]   Support for tracing block io actions                       . .
>  . .          IO Schedulers  --->                                        . .
>  . .
>                                .
>
>
