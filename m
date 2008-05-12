Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbYELHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbYELHzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbYELHyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:54:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:47591 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYELHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uD4b4Dgyv/1kHhe8HnrcQ8DVoANd9BzcHSwv58py8pj0YXJ1BvEIkWZZGL9VPXV6yXE8aCZgHXfSQXMekOseEQAnMo4HdE+/ICM+MpF2itv4wkQzFj1d5BtNXXbVD3lP9oVNkIg24vUOfuo0+axNVWW659HGjEKO5uar2mz0FkQ=
Message-ID: <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
Date: Mon, 12 May 2008 10:54:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Cc: "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Mel Gorman" <mel@skynet.ie>, mpm@selenic.com,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
X-Google-Sender-Auth: a8a13569ef5bfbfd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 10:38 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> > > What about the TPC performance regressions? My understanding was that
> > > slub still performed worse in the "object allocated on one CPU, freed on
> > > the other CPU" type workloads due to less batching.
> >
> > Which can be the majority of object allocations and frees in some
> > workloads.  It definately wants fixing.
>
>  Agreed, that situation is very frequency happend, IMHO.

Christoph fixed a tbench regression that was in the same ballpark as
the TPC regression reported by Matthew which is why we've asked the
Intel folks to re-test. But yeah, we're working on it.
