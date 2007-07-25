Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbXGYB1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbXGYB1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbXGYB07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:26:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:31126 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760821AbXGYB06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pcy5SRKmCB2E4m88O1idQNuotPPNYcv3yRkKXB3hvudLTJ5YEanEVx+atvlaXNQ9ig+IPTcn3PZ5X+E3+ogKUyfFpKeyGQqTdCokrpvUaOeFSGshy5cz3d96F5CVhIgFZi4/J8bET+SQEjqay8oBZS6l6oUBxh+gldZwm5qwtlw=
Message-ID: <b21f8390707241826o1422ca3aga9b6516a55dd961d@mail.gmail.com>
Date: Wed, 25 Jul 2007 11:26:57 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       "ck list" <ck@vds.kolivas.org>, linux-mm@kvack.org,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20070723221846.d2744f42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <20070723221846.d2744f42.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> The other consideration here is, as Nick points out, are the problems which
> people see this patch solving for them solveable in other, better ways?
> IOW, is this patch fixing up preexisting deficiencies post-facto?

So let me get this straight - you don't want to merge swap prefetch
which exists now and solves issues many people are seeing, and has
been tested more than a gazillion other bits & pieces that do get
merged - because it could be possible that in the future some other
patch, which doesn't yet exist and nobody is working on, may solve the
problem better?

You know what, just release Linux 0.02 as 2.6.23 because, using your
logic, everything that was merged since October 5, 1991 could be
replaced by something better.  Perhaps.  So there's obviously no point
having it there in the first place & there'll be untold savings in
storage costs and compilation time for the kernel tree, also bandwidth
for the mirror sites etc. in the mean time while we wait for the magic
pixies to come and deliver the one true piece of code that cannot be
improved upon.

> Well.  The above, plus there's always a lot of stuff happening in MM land,
> and I haven't seen much in the way of enthusiasm from the usual MM
> developers.

I haven't seen much in the way of enthusiasm from developers, period.
People are tired of maintaining patches for years that never get
merged into mainline because of totally bullshit reasons (usually
amounting to NIH syndrome)

-- 
Matt
