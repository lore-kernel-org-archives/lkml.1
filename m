Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYLRVme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYLRVme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLRVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:42:23 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:38951 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYLRVmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:42:22 -0500
Date: Thu, 18 Dec 2008 15:41:55 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
 hooks
In-Reply-To: <84144f020812181206o3d85fbd3t6b30346d7cf76d9d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812181541140.19680@quilx.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> 
 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com> 
 <494184AA.8090509@cs.helsinki.fi>  <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
  <1229597162.1047.48.camel@penberg-laptop>  <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
  <Pine.LNX.4.64.0812181048160.12300@quilx.com>  <1229619764.16418.54.camel@pc1117.cambridge.arm.com>
  <Pine.LNX.4.64.0812181334590.17255@quilx.com>
 <84144f020812181206o3d85fbd3t6b30346d7cf76d9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Pekka Enberg wrote:

> For kmemleak, that's a problem. Unless we explicitly annotate the
> caches, it will scan them and think that there's a pointer to a leaked
> object (i.e. false negative). Catalin already took care of the per-CPU
> caches but AFAICT we still need to take care of the per-node caches
> and the shared caches.

Why doesnt kmemleak simply use the counter as a boundary and only access
those pointers that are valid?

