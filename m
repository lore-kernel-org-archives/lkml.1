Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbXGYV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbXGYV2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXGYV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:28:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:34568 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbXGYV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DzFmR1+6kDJxQ3vpY5MJd8x5rtEcdQVqhvAV3WgmvT2uqjMDGXxUec4ajXKMhT3f23AxxwOSUQBUp0Qo2NyN5eDxB1vgGbl9WQu69tR3Jdqr4fgwTL3NF6DFkXD7nkzZzScUan3mkUZQix0O2APn9+J5cRQXL1z4Jz6zzrjDiSA=
Message-ID: <2c0942db0707251428r7a6a1cc9seea8dc59020f1bcb@mail.gmail.com>
Date: Wed, 25 Jul 2007 14:28:24 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Zan Lynx" <zlynx@acm.org>
Subject: Re: -mm merge plans for 2.6.23
Cc: "Rene Herman" <rene.herman@gmail.com>, david@lang.hm,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1185396952.9409.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <2c0942db0707250902v58e23d52v434bde82ba28f119@mail.gmail.com>
	 <1185396952.9409.5.camel@localhost>
X-Google-Sender-Auth: 78e9d740243a21e3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Zan Lynx <zlynx@acm.org> wrote:
> On Wed, 2007-07-25 at 09:02 -0700, Ray Lee wrote:
>
> > I'd just like updatedb to amortize its work better. If we had some way
> > to track all filesystem events, updatedb could keep a live and
> > accurate index on the filesystem. And this isn't just updatedb that
> > wants that, beagle and tracker et al also want to know filesystem
> > events so that they can index the documents themselves as well as the
> > metadata. And if they do it live, that spreads the cost out, including
> > the VM pressure.
>
> That would be nice.  It'd be great if there was a per-filesystem inotify
> mode.  I can't help but think it'd be more efficient than recursing
> every directory and adding a watch.
>
> Or maybe a netlink thing that could buffer events since filesystem mount
> until a daemon could get around to starting, so none were lost.

See "Filesystem Event Reporter" by Yi Yang, that does pretty much
exactly that. http://lkml.org/lkml/2006/9/30/98 . Author had things to
update, never resubmitted it as far as I can tell.

Ray
