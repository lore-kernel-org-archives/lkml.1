Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYIDHe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYIDHe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYIDHd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:33:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:22522 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYIDHdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OAuIvOuZxTxZUXGfBXK5AeoD3gjPa6Xt3kj2Op9M3VWslGOXRK088+L5+IfT0NPOIy
         LCHvokddGX7827Vm+Z1EcnuO2dXFYl6Zg1R6+DwM6JZ6Ms9UWHYCF7iESXqFMkJQdT9k
         qfe0+Ygo44FvSr9BmKdJTwOx1sjaPP/yn31IY=
Message-ID: <84144f020809040033h6872ecfdlfb7d7cdb57621b0d@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:33:54 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve VanDeBogart" <vandebo-lkml@nerdbox.net>
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       dkegel@google.com, jiayingz@google.com
In-Reply-To: <alpine.DEB.1.00.0809030833050.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	 <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
	 <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
	 <alpine.DEB.1.00.0809022036560.15543@abydos.NerdBox.Net>
	 <84144f020809030227jce7d3c2wab9e9c00b2fcdfe5@mail.gmail.com>
	 <alpine.DEB.1.00.0809030833050.15543@abydos.NerdBox.Net>
X-Google-Sender-Auth: aba84eac80d98db9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, Sep 3, 2008 at 6:42 PM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
> But which bits of a slab object should be marked as initialized at
> kmem_cache_alloc() time?  We can't mark all of them as initialized
> because the constructor may not initialize all of them (in fact, I've
> programmatically confirmed that there are constructors that don't
> initialize all the bytes of an object).  The only place to get the
> information of interest is to mark all bytes uninitialized and then
> run the constructor on the memory region.

Aah, indeed. We should fix kmemcheck as well then.

                      Pekka
