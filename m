Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZIKNpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZIKNpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIKNpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:45:22 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32741 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZIKNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:45:21 -0400
Date: Fri, 11 Sep 2009 09:45:01 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090911134501.GA24668@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz,
	Wu Fengguang <fengguang.wu@intel.com>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
 <20090911134241.GB19707@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911134241.GB19707@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AAA5460.0193:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 09:42:41AM -0400, Theodore Tso wrote:
> On Fri, Sep 11, 2009 at 09:34:03AM +0200, Jens Axboe wrote:
> > Hi,
> > 
> > (sorry if you receive this twice, the original posting had a mangled
> >  From address).
> > 
> > This is the 20th release of the writeback patchset. Changes since
> > v19 include:
> > 
> > - Drop the max writeback pages patch from Ted. I think we should do
> >   something to that effect, but there's really no reason to entangle
> >   it with this patchset.
> 
> That's reasonable, but I'd really like to know whether some VM hacker
> going to try to deal with this during the 2.6.32 window?  Such as
> maybe Wu Fengguang's patches, perhaps?  

Wu Fengguang's patches seem very reasonable to me.  My only concern is
that with tossing it in all at once.  I'd rather seen Jens' work go in
and then incremental benchmarking done afterward.

-chris
