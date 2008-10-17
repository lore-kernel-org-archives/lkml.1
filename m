Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYJQUPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYJQUPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYJQUPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:15:23 -0400
Received: from xenotime.net ([66.160.160.81]:47650 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751142AbYJQUPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:15:22 -0400
Date: Fri, 17 Oct 2008 13:15:20 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Fabio Comolli <fabio.comolli@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest GIT section mismatches
In-Reply-To: <b637ec0b0810171312y2bc88085o7973c257713b0d5c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810171314360.685@shark.he.net>
References: <b637ec0b0810171312y2bc88085o7973c257713b0d5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Fabio Comolli wrote:

> Linus ' GIT  2.6.27-05323-g26e9a39 (pulled less than one hour ago) gives:
> 
> WARNING: vmlinux.o(.text+0x1cde2): Section mismatch in reference from
> the function reserve_region_with_split() to the function
> .init.text:__reserve_region_with_split()
> The function reserve_region_with_split() references
> the function __init __reserve_region_with_split().
> This is often because reserve_region_with_split lacks a __init
> annotation or the annotation of __reserve_region_with_split is wrong.
> 
> WARNING: vmlinux.o(.cpuinit.text+0xeec): Section mismatch in reference
> from the function cpu_init() to the function
> .init.text:init_thread_xstate()
> The function __cpuinit cpu_init() references
> a function __init init_thread_xstate().
> If init_thread_xstate is only used by cpu_init then
> annotate init_thread_xstate with a matching annotation.
> 
> WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference
> from the variable initial_code to the function
> .init.text:i386_start_kernel()
> The variable __cpuinitdata initial_code references
> a function __init i386_start_kernel().
> If i386_start_kernel is only used by initial_code then
> annotate i386_start_kernel with a matching annotation.

so on i386.

Did you build with CONFIG_DEBUG_SECTION_MISMATCH=y ?

> I'll send .config on request.

-- 
~Randy
