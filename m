Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYLKJbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYLKJbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYLKJbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:31:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:32841 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYLKJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NuP7F5CIE6fCASma6hIwH3NktQw7OiW3+uvlX6HtuGUk0A4f8eHiJJ0b+CZL+Nrsxy
         c0CHps4clFdgGtzdigdSpn/jTdw2H4PWPrx1K87ignzXHULS9BpArA+z6Y1vt/xxfmXc
         fUor+ut/bOoSKF8NZO/huE+/jyeGTJaiajMuU=
Message-ID: <84144f020812110131w2824d251ge1273203639cf1c6@mail.gmail.com>
Date: Thu, 11 Dec 2008 11:31:29 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob kmem_cache_create
Cc: linux-kernel@vger.kernel.org, "Matt Mackall" <mpm@selenic.com>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 0fb88bc8392a92d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 7:36 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> It looks like the kmem_cache_create() function in the slob allocator
> passes the SLAB flags as GFP flags to the slob_alloc() function. The
> patch changes this call to pass GFP_KERNEL as the other allocators seem
> to do.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Matt Mackall <mpm@selenic.com>

Applied, thanks!
