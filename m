Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZB1FYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZB1FYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZB1FXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:23:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbZB1FXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:23:51 -0500
Date: Fri, 27 Feb 2009 21:23:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Simple brk allocator for very early allocations
Message-Id: <20090227212313.a6b4b43c.akpm@linux-foundation.org>
In-Reply-To: <1235785882-17580-1-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 17:51:17 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series adds a very simple brk-like allocator for very early
> allocations.  By default it extends the bss segment, starting at _end.
> 
> This is used to allocate x86-32's initial head_32.S pagetable, removing
> init_pg_table_start/end and pg0, replacing them with brk allocations.

Changelog fails to provide a reason for this?

> dmi_alloc() is also changed to use extend_brk.

Seems a large patchset just to clean up DMI a bit ;)

I assume that xen needs this?  domU or dom0?

