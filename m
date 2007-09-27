Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbXI0PiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbXI0PiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbXI0Ph5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:37:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:33948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXI0Ph4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:37:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="154980927"
Date: Thu, 27 Sep 2007 08:37:33 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070927153733.GF25718@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927022440.GB25873@linux-sh.org> <20070926210515.6725e745.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926210515.6725e745.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 09:05:15PM -0700, Randy Dunlap wrote:
> On Thu, 27 Sep 2007 11:24:40 +0900 Paul Mundt wrote:
> 
> > > +/* static helper functions */
> > > +static s32 max_compare(s32 v1, s32 v2)
> > > +{
> > > +	if (v1 < v2)
> > > +		return v2;
> > > +	else
> > > +		return v1;
> > > +}
> > > +
> > > +static s32 min_compare(s32 v1, s32 v2)
> > > +{
> > > +	if (v1 < v2)
> > > +		return v1;
> > > +	else
> > > +		return v2;
> > > +}
> > > +
> > min()/max() instead?
> 
> Other code wants function pointers to the min & max functions.
> That's why they are here AFAICT.
> 
> 
> > > +/* assumes qos_lock is held */
> > > +static void update_target(int i)
> > > +{
> > 'target' might be a more meaningful variable name.
> 
> Anything but 'i'.

The 'i' is gone.  Will post new patch later today.

--mgross
