Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYKTSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYKTSYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYKTSYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:24:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:64347 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYKTSYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gpBC7ZeXbSIrpXRBK8r0cIME3oUndfEFeJbJJqyRaO/x0qUdx6in2nFtxp3XYKH8kN
         LCfaLQbImcZVRyZfdBVuAujoHf8KlWXYQm29OmJrietprPk5EtPnOrheZkmOemDgWNYg
         uQZlVK3xsDEv5Opswp8rBA/GQtrSM1EIlL5OE=
Date: Thu, 20 Nov 2008 21:24:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: slab - __cache_alloc NULL prefetch fix
Message-ID: <20081120182437.GA22100@localhost>
References: <20081120164400.GC7363@localhost> <20081120170148.GD7363@localhost> <Pine.LNX.4.64.0811201216110.23154@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811201216110.23154@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Thu, Nov 20, 2008 at 12:16:28PM -0600]
| On Thu, 20 Nov 2008, Cyrill Gorcunov wrote:
| 
| > even having prefetch(NULL) as valid we do check if
| > object is not NULL anyway so I thought there is no
| > need to prefetch(NULL) in case of fail.
| 
| The object is only checked if SLAB_DEBUG is on.
| 

My fault Christoph, I've been messed by kmemcheck_slab_alloc
which in turn actually becomes zero function if not tuned on.
So -- all is fine, sorry for noise.

		- Cyrill -
