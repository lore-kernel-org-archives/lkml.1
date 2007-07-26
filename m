Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbXGZBPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbXGZBPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbXGZBPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:15:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:32764 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbXGZBPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NFqPsJy2c586ixj4IHlom3uL2JwQeADDinxoh4FHdxIXSyo5RpiElGcEgNFHlTxsVaJN7ZoaYZR4hUS8whFj0zior0bf0wsbIf+VEnH2bGr5ghUjOvU4YnRXiSWfoTMojeySwlvH491lhfJ/WxkdcgrXv/8UcEaJtPGMLVOdJ8g=
Message-ID: <b21f8390707251815o767590acrf6a6c4d7290a26a8@mail.gmail.com>
Date: Thu, 26 Jul 2007 11:15:41 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org
In-Reply-To: <2c0942db0707250902v58e23d52v434bde82ba28f119@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <2c0942db0707250902v58e23d52v434bde82ba28f119@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> I'd just like updatedb to amortize its work better. If we had some way
> to track all filesystem events, updatedb could keep a live and
> accurate index on the filesystem. And this isn't just updatedb that
> wants that, beagle and tracker et al also want to know filesystem
> events so that they can index the documents themselves as well as the
> metadata. And if they do it live, that spreads the cost out, including
> the VM pressure.

We already have this, its called inotify (and if I'm not mistaken,
beagle already uses it).  Several years ago when it was still a little
flakey patch, I built a custom filesystem indexer into an enterprise
search engine using it (I needed to pull apart Unix mbox files).  The
only trouble of course is the action is triggered immediately, which
may not always be ideal (but that's a userspace problem)

-- 
Matt
