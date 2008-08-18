Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYHRVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYHRVWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHRVWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:22:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbYHRVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:22:05 -0400
Date: Mon, 18 Aug 2008 14:21:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: andreas.herrmann3@amd.com, hannes@saeurebad.de, mingo@elte.hu,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alloc_bootmem_core: fix misaligned allocation of 1G
 page
Message-Id: <20080818142142.ad065339.akpm@linux-foundation.org>
In-Reply-To: <20080818141718.bec87aa6.akpm@linux-foundation.org>
References: <20080812095336.GE5952@alberich.amd.com>
	<877iam41bk.fsf@skyscraper.fehenstaub.lan>
	<20080813164121.GA5985@alberich.amd.com>
	<87tzdo93tv.fsf@skyscraper.fehenstaub.lan>
	<20080813193158.GB5985@alberich.amd.com>
	<20080818141718.bec87aa6.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 14:17:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 13 Aug 2008 21:31:58 +0200
> Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > > Attached is a version that should be easier to read.  Please
> > > double-check.
> > 
> > Nice.
> > That's the preferred solution and should replace my initial fix.
> > 
> > Reviewed-and-tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> Johannes, I'm unsure whether that patch was the final version.  Could
> you please resend it (or its successor)?
> 
> With a more complete changelog, please.  This:
> 
>     bootmem: fix aligning of node-relative indexes and offsets
> 
> doesn't explain what needed fixing, nor how it was fixed, nor the
> consequences of leaving it unfixed, etc.
> 

ah, OK, I found it.  please ignore.
