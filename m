Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZKCHlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZKCHlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZKCHlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:41:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbZKCHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:41:46 -0500
Date: Mon, 2 Nov 2009 23:41:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] drm: kill more unused DRM macros
Message-Id: <20091102234124.2655e61d.akpm@linux-foundation.org>
In-Reply-To: <20091019013708.6ca3c7df@mycelium.queued.net>
References: <20091019013708.6ca3c7df@mycelium.queued.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 01:37:08 -0400 Andres Salomon <dilinger@collabora.co.uk> wrote:

> There are a few more macros in drmP.h that are unused; DRM_GET_PRIV_SAREA,
> DRM_ARRAY_SIZE, and DRM_WAITCOUNT can go away completely.
> 
> Unfortunately, DRM_COPY is still used in one place, but we can at least
> move it to where it's used.  It's an awful looking macro..

It would have been nice to fix the (valid) checkpatch warnings while
you were there.

