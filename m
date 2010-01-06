Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247Ab0AFIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0AFIUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 03:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763Ab0AFIUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 03:20:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:61149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab0AFIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 03:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eZoLkIL+P92G8++PzE5dLt9ye2RcvspSao5tbO/9SW+4KmQeSCqKMfo0mNUW1zdsjO
         JKQ4KpwqW51cHWNPoZcQF+tQ2ifdC8m9POMENwNa5DWzTQKezD9UH86agW42SwZW5Yjl
         qCO7hah47e2V+mRiU1T52DPK4nfqhpIX7hN9E=
MIME-Version: 1.0
In-Reply-To: <4B443AE3.2080800@linux.intel.com>
References: <4B443AE3.2080800@linux.intel.com>
Date: Wed, 6 Jan 2010 10:20:42 +0200
X-Google-Sender-Auth: a49e5b87007d89ee
Message-ID: <84144f021001060020v57535d5bwc65b482eca669bc5@mail.gmail.com>
Subject: Re: [PATCH v3] slab: initialize unused alien cache entry as NULL at 
	alloc_alien_cache().
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 9:25 AM, Haicheng Li <haicheng.li@linux.intel.com> wrote:
> Comparing with existing code, it's a simpler way to use kzalloc_node()
> to ensure that each unused alien cache entry is NULL.
>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: Andi Kleen <ak@linux.intel.com>
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> Reviewed-by: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>

I can find a trace of Andi acking the previous version of this patch
but I don't see an ACK from Christoph nor a revieved-by from Matt. Was
I not CC'd on those emails or what's going on here?

                        Pekka
