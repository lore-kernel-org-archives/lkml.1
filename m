Return-Path: <linux-kernel-owner+w=401wt.eu-S933426AbZFLJZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbZFLJZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZFLJYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:24:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36134 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbZFLJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oYvpZJ7zavilmn+5GSPbO+XnEu8sR1oDOJPj1nexDcA8fp4aOxNGPPkJ22oLR1vYRU
         n/rG1T+f4uzx7PP5/m2OM3dfFJGwjiFvekd2W61fqbyaveNcrFsg82XHcZ2Y33pXZzvZ
         Kpfm6CR1GmrzkbQ9d/MeOlJy3fJ3zZWZ9/YNU=
MIME-Version: 1.0
In-Reply-To: <1244798515.7172.99.camel@pasglop>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu> <1244798515.7172.99.camel@pasglop>
Date: Fri, 12 Jun 2009 12:24:55 +0300
X-Google-Sender-Auth: 8f3fdccc091f9eef
Message-ID: <84144f020906120224v5ef44637pb849fd247eab84ea@mail.gmail.com>
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
	suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Jun 12, 2009 at 12:21 PM, Benjamin
Herrenschmidt<benh@kernel.crashing.org> wrote:
> I really think we are looking for trouble (and a lot of hidden bugs) by
> trying to "fix" all callers, in addition to making some code like
> vmalloc() more failure prone because it's unconditionally changed from
> GFP_KERNEL to GFP_NOWAIT.

It's a new API function vmalloc_node_boot() that uses GFP_NOWAIT so I
don't share your concern that it's error prone.

                                              Pekka
