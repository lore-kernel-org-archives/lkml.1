Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYGUKQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYGUKQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYGUKQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:16:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:39277 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYGUKQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wdtA/ljvjK0FSP9sXkcSr954Iplhb456d693J7nkV13tQSwQfk5kNENpvXub8AU140
         Omkq/hxHodxw/c1IliTbpRS6SVapcGgM8UhyXUAOkQjKGYGBjpnW/Oqkm6EgQwV83Q4B
         qPSLE4gRUqb4HjaUh1+/ehQPq+mXfKCdov05g=
Date: Mon, 21 Jul 2008 14:16:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup() and check failing allocation
Message-ID: <20080721101623.GB7694@lenovo>
References: <48845FAC.9070500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48845FAC.9070500@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Li Zefan - Mon, Jul 21, 2008 at 06:06:36PM +0800]
| - use kstrdup() instead of kmalloc() + memcpy()
| - return NULL if allocating ->mnt_devname failed
| - mnt_devname should be const
| 
| Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
| ---
| 
|   Andrew, please drop vfs-use-kstrdup.patch
| 
| ---

Thanks Li. I think Al will be fine with this version.

So if you needed:
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

		- Cyrill -
