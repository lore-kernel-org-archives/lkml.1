Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYGUNYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYGUNYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYGUNYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:24:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59390 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYGUNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:24:38 -0400
Date: Mon, 21 Jul 2008 14:24:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup() and check failing allocation
Message-ID: <20080721132429.GE28946@ZenIV.linux.org.uk>
References: <48845FAC.9070500@cn.fujitsu.com> <20080721101623.GB7694@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721101623.GB7694@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 02:16:23PM +0400, Cyrill Gorcunov wrote:
> [Li Zefan - Mon, Jul 21, 2008 at 06:06:36PM +0800]
> | - use kstrdup() instead of kmalloc() + memcpy()
> | - return NULL if allocating ->mnt_devname failed
> | - mnt_devname should be const
> | 
> | Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> | ---
> | 
> |   Andrew, please drop vfs-use-kstrdup.patch
> | 
> | ---
> 
> Thanks Li. I think Al will be fine with this version.
> 
> So if you needed:
> Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

Applied.
