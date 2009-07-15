Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZGOGjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZGOGjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZGOGjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:39:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZGOGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:39:15 -0400
Subject: RE: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails
 due to low memory
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       David Howells <dhowells@redhat.com>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA045E8C0F@chinexm1.ad.analog.com>
References: <1247581357-20068-1-git-send-email-vapier@gentoo.org>
	 <1247581838.7500.98.camel@twins>
	 <0F1B54C89D5F954D8535DB252AF412FA045E8C0F@chinexm1.ad.analog.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Jul 2009 08:38:03 +0200
Message-Id: <1247639883.7500.193.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't top post.

On Wed, 2009-07-15 at 11:29 +0800, Zhang, Sonic wrote:

> From: Peter Zijlstra [mailto:peterz@infradead.org] 
> > Sent: Tuesday, July 14, 2009 10:31 PM
> > To: Mike Frysinger
> > Cc: linux-kernel@vger.kernel.org;
> > uclinux-dist-devel@blackfin.uclinux.org; Zhang, Sonic; David Howells
> > Subject: Re: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails
> > due to low memory
> > 
> > On Tue, 2009-07-14 at 10:22 -0400, Mike Frysinger wrote:
> > > From: Sonic Zhang <sonic.zhang@analog.com>
> > > 
> > > Since no-mmu systems tend to be memory constrained, we want to drop 
> > > all of the page cache whenever memory gets low.  The only other option
> > 
> > > is to invoke the oom killer, and clearly that's not ideal.
> > 
> > Uhm,.. normally reclaim will already try to drop pagecache.

> The reclaim is not that aggressive.

Well, then maybe we should fix that instead?
