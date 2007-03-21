Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXCUNNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXCUNNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXCUNNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:13:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:7363 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXCUNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qeKzWI9EjOSR0EXjwgEpZsdSr+va1H6S69nlT5Uy+Ec8jVYAEmQNTsmvCZ54yO13B8tpavBcEzI8IsbpZvfbAGgW6MTx37erH6zl2eHjBrium2nGIYBq6BUSs+DmIvc3F4vZkd8nohHr5xqfO7w1w/Cs/6Y5vB7dKpoCT691rQA=
Message-ID: <84144f020703210613p62bfa578rb8ece4da39b00faf@mail.gmail.com>
Date: Wed, 21 Mar 2007 15:13:21 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH] SLAB : Dont allocate empty shared caches
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <christoph@lameter.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4600DD13.80305@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070320181235.77d28864.dada1@cosmosbay.com>
	 <Pine.LNX.4.64.0703201248530.12664@graphe.net>
	 <20070320213218.GA13952@one.firstfloor.org>
	 <46005B7D.3090701@cosmosbay.com>
	 <Pine.LNX.4.64.0703201715110.17799@graphe.net>
	 <4600D04B.6030305@cosmosbay.com> <4600D756.7070500@cosmosbay.com>
	 <4600DD13.80305@cosmosbay.com>
X-Google-Sender-Auth: 1f46058603f12867
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> We can avoid allocating empty shared caches and avoid unecessary check of
> cache->limit. We save some memory. We avoid bringing into CPU cache unecessary
> cache lines.
>
> All accesses to l3->shared are already checking NULL pointers so this patch is
> safe.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
