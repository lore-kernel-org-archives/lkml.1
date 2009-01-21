Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZAUVNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZAUVNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZAUVMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:12:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:54001 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZAUVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KMABsJ8Tj2dqTQFlBzbd6SRvup0kgKV3tSov/YKg+Lw0P49/yl6db+4K+U3/zzW+mB
         plX87tuDeh+1Vux3pydBAGL21mCTBV/rQfc9VAH9C3dJZejvGshT8hjFbpDKD+3g/Viv
         W6fJzW6k4wcq1cuaGkLPDtVc7kBC3y/3Bgykw=
Date: Wed, 21 Jan 2009 23:13:19 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: ????????? <liushengping@tsinghua.org.cn>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kmemtrace(slab and slub, except slob) doesn't work on PPC64
	board,
Message-ID: <20090121211318.GA5272@localhost>
References: <18682661.270411232413952442.JavaMail.coremail@mailserver2> <49770EB3.5040404@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49770EB3.5040404@cs.helsinki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 02:01:55PM +0200, Pekka Enberg wrote:
> (I am cc'ing linux-kernel)
>
>
> Hmm, I can't really work out what exactly is going wrong there. I suspect 
> that the fact that ppc64 uses kmem_cache_alloc() for __pud_alloc() -> 
> pud_alloc_one() whereas x86 uses the page allocator is the culprit here.
>
> Eduard, thoughts?
>
> 		Pekka

Couldn't it be the same problem Ingo ran into? This is the relay
version, as far as I can tell. I'd suggest trying the ftrace version of
kmemtrace. In any case, it has been more recently updated.

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git


	Eduard

