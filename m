Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbZK3Ro1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbZK3Ro1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZK3RoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:44:25 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50951 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZK3RoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:44:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=V7/P2vX3TJZqEIQ94eq+r+dbL0vnKIdBIHFq1xRT6qvTrtKs7zeBHEgoB1gHBuUdb9
         Otb3dihfNov1lbtdn+4tiSdTywtHe7pFqvREU837KPyGXImPypisgoxHf8eOl1HjLT4R
         nGFplNDNEON8ymBlyNw24Lwi7CAIwrp/zTDwU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0911300926150.14098@router.home>
References: <cover.1259059549.git.tim@klingt.org> <4B0BBBA8.2090604@klingt.org>
	 <20091124112058.GA23765@elte.hu>
	 <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
	 <4B125CC2.7000202@klingt.org> <4B138AC2.7080008@cs.helsinki.fi>
	 <alpine.DEB.2.00.0911300926150.14098@router.home>
Date: Mon, 30 Nov 2009 19:44:27 +0200
X-Google-Sender-Auth: 20d258f1da49a2aa
Message-ID: <84144f020911300944x89309c5r8e9079e1a62fb416@mail.gmail.com>
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tim Blechmann <tim@klingt.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 6:09 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Mon, 30 Nov 2009, Pekka Enberg wrote:
>
>> OK, so it's the generic alloc_skb() function that keeps hitting
>> kmem_cache_alloc_node() with "-1". Christoph, are you okay with removing the
>> unlikely() annotation from __cache_alloc_node()?
>
> Yes. Lets look for other cases in the allocators too.
> kmem_cache_alloc_node used to be mainly used for off node allocations but
> the network alloc_skb() case shows that this is changing now.

Tim, can you please re-send the patch to me so I can apply it?
