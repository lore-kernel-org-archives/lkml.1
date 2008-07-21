Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYGUKSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYGUKSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYGUKSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:18:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60064 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbYGUKSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:18:13 -0400
Subject: Re: [PATCH] vfs: use kstrdup() and check failing allocation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080721101623.GB7694@lenovo>
References: <48845FAC.9070500@cn.fujitsu.com> <20080721101623.GB7694@lenovo>
Date: Mon, 21 Jul 2008 13:18:15 +0300
Message-Id: <1216635495.19173.48.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 14:16 +0400, Cyrill Gorcunov wrote:
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

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

