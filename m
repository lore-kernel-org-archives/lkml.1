Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYLJSee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYLJSee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbYLJScU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:32:20 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33341 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbYLJScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:32:19 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 10:32:16 -0800
Message-Id: <1228933936.9737.83.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 18:27 +0000, Catalin Marinas wrote:
> This patch adds the callbacks to memleak_(alloc|free) functions from
> the slab allocator. The patch also adds the SLAB_NOLEAKTRACE flag to
> avoid recursive calls to kmemleak when it allocates its own data
> structures.

You might also want to try linux-mm@kvack.org for these.  You'll
probably get some better review there, and they're just _kinda_ mm
related. ;)

-- Dave

