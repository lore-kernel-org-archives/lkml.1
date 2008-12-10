Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYLJUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYLJUHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYLJUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:07:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:61106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYLJUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:07:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h9ke72vIySYISyuN31G9XkkB18qNoiKN5BBCvSi5CR97/HbkkAUnBXmT5Nb07SlY4c
         mZQIa1CfFfzW0hwdL7f/R51/CU9EEla1C7UO7lwXcIl1cZ/jlkOJDbL4CPr5fQrR9Ki7
         mcHXFe5GX68pWWtULR/CpCbfoUoKkYWrmMBII=
Date: Wed, 10 Dec 2008 23:06:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob
	kmem_cache_create
Message-ID: <20081210200657.GB2215@localhost>
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com> <20081210193421.GA2215@localhost> <1228939070.3726.134.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228939070.3726.134.camel@calx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Matt Mackall - Wed, Dec 10, 2008 at 01:57:50PM -0600]
... 
| I think that's fine. Notice that this is not the allocation of an
| object, but the allocation of a cache descriptor. We save the flags
| inside the descriptor so that when the user calls kmem_cache_alloc, we
| can pass them along to slob_alloc, where GFP_ZERO can take effect.
| 
| So, if we're comfortable with the idea that we can only create caches in
| 'normal' contexts, then I think the patch is fine.
| 
| -- 
| Mathematics is the supreme nostalgia of our time.
| 

Yes Matt, somehow missed that.

		- Cyrill -
