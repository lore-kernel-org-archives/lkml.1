Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZBGRZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZBGRZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZBGRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:24:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbZBGRYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:24:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Date: Sat, 7 Feb 2009 18:23:53 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20090206031125.693559239@cmpxchg.org> <20090206130009.99400d43.akpm@linux-foundation.org> <20090206232747.GA3539@cmpxchg.org>
In-Reply-To: <20090206232747.GA3539@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071823.54259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009, Johannes Weiner wrote:
> On Fri, Feb 06, 2009 at 01:00:09PM -0800, Andrew Morton wrote:
> > On Fri, 6 Feb 2009 05:49:07 +0100
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > > and, I think you should mesure performence result.
> > > 
> > > Yes, I'm still thinking about ideas how to quantify it properly.  I
> > > have not yet found a reliable way to check for whether the working set
> > > is intact besides seeing whether the resumed applications are
> > > responsive right away or if they first have to swap in their pages
> > > again.
> > 
> > Describing your subjective non-quantitative impressions would be better
> > than nothing...
> 
> Okay.
> 
> > The patch bugs me.
> 
> Please ignore it, it is broken as is.  My verbal cortex got obviously
> disconnected from my code cortex when writing the changelog...

If I understood this correctly, patch 3/3 is to be disregarded.

> And I will reconsider the actual change bits, I still think that we
> shouldn't scan anon page lists while may_swap is zero.

Hm, can you please remind me what may_swap == 0 acutally means?

Rafael
