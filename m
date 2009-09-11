Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZIKNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZIKNmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIKNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:42:42 -0400
Received: from thunk.org ([69.25.196.29]:43704 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZIKNml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:42:41 -0400
Date: Fri, 11 Sep 2009 09:42:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090911134241.GB19707@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz,
	Wu Fengguang <fengguang.wu@intel.com>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 09:34:03AM +0200, Jens Axboe wrote:
> Hi,
> 
> (sorry if you receive this twice, the original posting had a mangled
>  From address).
> 
> This is the 20th release of the writeback patchset. Changes since
> v19 include:
> 
> - Drop the max writeback pages patch from Ted. I think we should do
>   something to that effect, but there's really no reason to entangle
>   it with this patchset.

That's reasonable, but I'd really like to know whether some VM hacker
going to try to deal with this during the 2.6.32 window?  Such as
maybe Wu Fengguang's patches, perhaps?  

Or do I need to put in some kind of hack into ext4 ala what XFS did to
work around this problem until we can come up with a longer-term fix?

     	    	 	       	      	   - Ted
