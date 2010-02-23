Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0BWCZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:25:44 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:34066 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752515Ab0BWCZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:25:43 -0500
Date: Tue, 23 Feb 2010 13:25:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Ankit Jain <radical@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] Make VM_MAX_READAHEAD a kernel parameter
Message-ID: <20100223022527.GB22370@discord.disaster>
References: <201002091659.27037.knikanth@suse.de> <201002111715.04411.knikanth@suse.de> <20100214213724.GA28392@discord.disaster> <201002151006.37294.knikanth@suse.de> <20100221142600.GA10036@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100221142600.GA10036@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 10:26:00PM +0800, Wu Fengguang wrote:
> Nikanth,
> 
> > > > +	readahead=	Default readahead value for block devices.
> > > > +
> > > 
> > > I think the description should define the units (kb) and valid value
> > > ranges e.g. page size to something not excessive - say 65536kb.  The
> > > above description is, IMO, useless without refering to the source to
> > > find out this information....
> > > 
> > 
> > The parameter can be specified with/without any suffix(k/m/g) that memparse() 
> > helper function can accept. So it can take 1M, 1024k, 1050620. I checked other 
> > parameters that use memparse() to get similar values and they didn't document 
> > it. May be this should be described here.
> 
> Hope this helps clarify things to user:
> 
> +       readahead=nn[KM]
> +                       Default max readahead size for block devices.
> +                       Range: 0; 4k - 128m

Yes, that is exactly what I was thinĸing of. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
