Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYJTSEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYJTSEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYJTSEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:04:00 -0400
Received: from waste.org ([66.93.16.53]:37262 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYJTSEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:04:00 -0400
Subject: Re: [PATCH] Export tiny shmem_file_setup for DRM-GEM
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>, Nick Piggin <npiggin@suse.de>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810191242220.22825@blonde.site>
References: <Pine.LNX.4.64.0810191242220.22825@blonde.site>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 13:02:34 -0500
Message-Id: <1224525754.4323.21.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 12:52 +0100, Hugh Dickins wrote:
> We're trying to keep the !CONFIG_SHMEM tiny-shmem.c (using ramfs without
> swap) in synch with CONFIG_SHMEM shmem.c (and mpm is preparing patches
> to combine them).  I was glad to see EXPORT_SYMBOL_GPL(shmem_file_setup)
> go into shmem.c, but why not support DRM-GEM when !CONFIG_SHMEM too?
> But caution says still depend on MMU, since !CONFIG_MMU is.. different.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Matt Mackall <mpm@selenic.com>

Hugh, what path do you usually take for upstreaming shmem bits and what
path should I take with my unify patch?

-- 
Mathematics is the supreme nostalgia of our time.

