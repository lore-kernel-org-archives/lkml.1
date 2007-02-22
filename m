Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbXBVJp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbXBVJp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXBVJp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:45:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52596 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbXBVJp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aj/9FM4oeD/Crx5OYK7r/7D+T/7PUSEVEEQ8hu1zlwOc9OMk+hW9lU2N1pQxZ1y9fWklWP9QaP5HF0+plRkquGeUjZKu5s9NjOKGmuQQEkibK9EGLZOuviUh24O28xmTas3uwNacaWEnpCAv5SQGwfngGW7orXou9hwu5MkLYmc=
Message-ID: <84144f020702220145h4f670ec6g428dc046ee9dcc71@mail.gmail.com>
Date: Thu, 22 Feb 2007 11:45:53 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/29] mm: kmem_cache_objs_to_pages()
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Thomas Graf" <tgraf@suug.ch>, "David Miller" <davem@davemloft.net>
In-Reply-To: <1172136508.6374.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144842.299190000@taijtu.programming.kicks-ass.net>
	 <84144f020702210747t50d7d92ei1a2f5da8bf117d40@mail.gmail.com>
	 <1172136508.6374.41.camel@twins>
X-Google-Sender-Auth: 5d1d6c34a8d1175c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, 2007-02-21 at 17:47 +0200, Pekka Enberg wrote:
> > So how does this work? You ask the slab allocator how many pages you
> > need for a given number of objects and then those pages are available
> > to it via the page allocator? Can other users also dip into those
> > reserves?

On 2/22/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Everybody (ab)using PF_MEMALLOC or the new __GFP_EMERGENCY.

So you are only interested in rough estimation of how much many pages
you need for a given amount of objects? Why not use ksize() for that
then?

                                    Pekka
