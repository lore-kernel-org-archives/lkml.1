Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXEETTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXEETTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXEETTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:19:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:47123 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbXEETTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OSqtttFqXFLgf2gA0H8G0t0m0Nu4ZcLiuzTAxDrQ0EhDHR6KVKT+FNQUxX/ShTfMnvT5Y5EDdjU0io2txjaaNHyEtuZIrAR6hscaEsGPhRSiRm9WuVIST8NyBo/7fLkM0uXUkbiYi+RED1hLMdgHZEYhKeleP50RNsTsnAy+fvc=
Message-ID: <84144f020705051219m15d3828bp6e4697c74a3005ce@mail.gmail.com>
Date: Sat, 5 May 2007 22:19:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [-mm patch] fix unionfs compilation
Cc: "Adrian Bunk" <bunk@stusta.de>, jsipek@cs.sunysb.edu,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org
In-Reply-To: <20070505115718.a1a0b61e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	 <20070505170012.GF8975@stusta.de>
	 <20070505115718.a1a0b61e.akpm@linux-foundation.org>
X-Google-Sender-Auth: 3b888c9e4b3baf5f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Bah, that was hidden from my allmodconfig because CONFIG_UNIONFS is inexplicably
> dependent upon CONFIG_SLAB.
>
> How come?

I think Adrian added it before we introduced krealloc() to fix uniofs
from poking slab internals.
