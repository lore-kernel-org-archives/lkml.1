Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZABAA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZABAA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 19:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZABAAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 19:00:13 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:30240 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbZABAAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 19:00:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUCAAvoXEl5LB1fgWdsb2JhbACTeQEBFiK2OoVy
X-IronPort-AV: E=Sophos;i="4.36,315,1228051800"; 
   d="scan'208";a="285411731"
Date: Fri, 2 Jan 2009 11:00:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
       kmannth@us.ibm.com, linux-kernel@vger.kernel.org, sekharan@us.ibm.com,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org
Subject: Re: Defrag support for inodes / dentries etc
Message-ID: <20090102000002.GJ10725@disturbed>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
	kmannth@us.ibm.com, linux-kernel@vger.kernel.org,
	sekharan@us.ibm.com, Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel@vger.kernel.org
References: <1227561983.6487.32.camel@keith-laptop> <20081125091917.GU26308@kernel.dk> <20081230113514.fe09d495.akpm@linux-foundation.org> <20081230114138.cd9e9763.akpm@linux-foundation.org> <84144f020812301208i34e5cc73hac25675f56e6aac0@mail.gmail.com> <Pine.LNX.4.64.0812311657050.21595@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812311657050.21595@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 05:04:04PM -0600, Christoph Lameter wrote:
> On Tue, 30 Dec 2008, Pekka Enberg wrote:
> 
> > > I'll need to revert to yesterday's linux-next I think.  Pekka, has
> > > that stuff been dropped?
> >
> > Yup, there hasn't been any activity after the last merge window so I'm
> > not expecting to be able to merge it for 2.6.29. As per linux-next
> > rules, I dropped the 2.6.30 material until the merge window closes.
> > The code is in topic/slub-defrag of slab.git, though.
> 
> Well the problem currently is that there is no driver for these features.
> There has been a request for this functionality for a long time but both
> the primary drivers for this (Dave Chinner and I) are no longer with the
> company for which we started the project. I'd be glad to continue this
> if there would be an interest by the filesystem developers.

Certainly. The problem hasn't gone away and anyone trying to run
a busy fileserver while know of the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
