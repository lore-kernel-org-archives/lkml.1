Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYABSaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYABSaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYABSaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:30:04 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:42079 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYABSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:30:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HxZvCSp9YfhSG8d+DgRUl9I8ZJKwpRoJOwO7fgP/V+I6MHSBOrh+4FrUvt8h8PS/uywOM/Ql2flCBwt+lJIfNhXjFV6GsglfvWcZodSvg+hyp6btSGjg2JXD8qj9exxCmMDoxes22ohnx3NTuUMuDhmw2tEmAJrVskYSENRSRy0=
Message-ID: <64bb37e0801021029u1735bb9eta53906b123abf577@mail.gmail.com>
Date: Wed, 2 Jan 2008 19:29:59 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.24-rc6-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Neil Brown" <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       netdev@vger.kernel.org, "Tom Tucker" <tom@opengridcomputing.com>
In-Reply-To: <20080101120406.GA27209@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	 <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
	 <64bb37e0712281453y4aac82b7h7acc8ec314ca6e3e@mail.gmail.com>
	 <20071228150746.42b3bbc0.akpm@linux-foundation.org>
	 <64bb37e0712290851r6d41768dk270e47884713a3de@mail.gmail.com>
	 <20071230013021.GA13603@gondor.apana.org.au>
	 <64bb37e0712291934o77a3d365h56c9c31ac8437469@mail.gmail.com>
	 <64bb37e0712311215x519b10e9kd51eb745b3b7290a@mail.gmail.com>
	 <20080101120406.GA27209@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 1, 2008 1:04 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> In any case, I suspect the cause of your problem is that somebody
> somewhere is doing a double-free on an skb.
>
> Since you're the only person who can reproduce this, we really need
> your help to track this down.  Since bisecting the mm tree is not
> practical, you could start by checking whether the bug is in mm only
> or whether it affects rc6 too.

Vanilla 2.6.24-rc6 seems stable. I did not see any crash or warnings.

Torsten
