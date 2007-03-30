Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXC3QwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXC3QwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXC3QwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:52:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:55579 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXC3QwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oF+IIEuY66Qafcsrj7aZU2tqO1k0gCtPcumxRUW71jbpVVLu8DFn7M3H435vYc5QWsTezQBgHSgBNcX2e1O4Yd1SXSwy4bfPAyglIBpCk7u+bW3MI/yyramxDp6c6kjT6QJowDMVUE8q5IPN5DOxbkbLQ88eyCbgJ1WNRNyTbE0=
Date: Fri, 30 Mar 2007 20:41:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] check for mem in slab
Message-ID: <20070330164104.GA10173@cvg>
References: <20070329160434.GA10265@cvg> <20070330065641.GA8365@osiris.boeblingen.de.ibm.com> <84144f020703300455i4fe6bdc5yf4389c2105487bb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020703300455i4fe6bdc5yf4389c2105487bb0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Fri, Mar 30, 2007 at 02:55:26PM +0300]
| On 3/30/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
| >> in file mm/slab.c and routine kmem_cache_init() I found there
| >> is no checking for allocated memory on line:
| >>
| >>       /* 4) Replace the bootstrap head arrays */
| >>       {
| >>               struct array_cache *ptr;
| >>
| >>               ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
| >>
| >> --> no check for ptr == NULL <--
| >[...]
| >> is that OK? or it's a bug?
| >
| >It's ok. If that allocation fails your machine won't come up anyway.
| 
| We ought to add a BUG_ON or comment at least there as this keeps
| popping up again and again.
| 

Thanks for answer

		Cyrill

