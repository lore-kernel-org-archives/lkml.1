Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbZJTJUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbZJTJUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZJTJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:20:31 -0400
Received: from mga12.intel.com ([143.182.124.36]:56824 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751345AbZJTJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 05:20:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,590,1249282800"; 
   d="scan'208";a="201129468"
Date: Tue, 20 Oct 2009 11:22:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: twl4030-power: Rename DEVGROUP to DEV_GRP
Message-ID: <20091020092227.GB5563@sortiz.org>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
 <1255954244-28873-1-git-send-email-amit.kucheria@verdurent.com>
 <20091019192646.GC30203@sortiz.org>
 <20091020060713.GV32041@smtp.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020060713.GV32041@smtp.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Tue, Oct 20, 2009 at 09:07:13AM +0300, Amit Kucheria wrote:
> On 09 Oct 19, Samuel Ortiz wrote:
> > Hi Amit,
> > 
> > I've applied patches 1,2 and 3 to my for-next branch.
> > I dont think patch 4 is really useful, and I'll wait for an ACK from Tony or
> > Nokia before pushing patch 5.
> > 
> > Thanks for your work.
> > 
> > Cheers,
> > Samuel.
> 
> Samuel,
> 
> I hope you meant you're taking patches 1, 2, 4 and 5.
Yes, sorry about it. So, patches 1,2,4 and 5 applied.

Cheers,
Samuel.

 
> 3 is the one just moving stuff around and may be discarded.
> 
> Thanks.
> 
> Regards,
> Amit
> 
> > On Mon, Oct 19, 2009 at 03:10:44PM +0300, Amit Kucheria wrote:
> > > Stick to the names used in the reference manual
> > > 
> > > Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> > > Cc: sameo@linux.intel.com
> > > Cc: linux-omap@vger.kernel.org
> > > ---
> > >  drivers/mfd/twl4030-power.c |   16 ++++++++--------
> > >  1 files changed, 8 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > > index d423e0c..82e3bcb 100644
> > > --- a/drivers/mfd/twl4030-power.c
> > > +++ b/drivers/mfd/twl4030-power.c
> > > @@ -69,12 +69,12 @@ static u8 twl4030_start_script_address = 0x2b;
> > >  
> > >  /* resource configuration registers */
> > >  
> > > -#define DEVGROUP_OFFSET		0
> > > +#define DEV_GRP_OFFSET		0
> > >  #define TYPE_OFFSET		1
> > >  
> > > -/* Bit positions */
> > > -#define DEVGROUP_SHIFT		5
> > > -#define DEVGROUP_MASK		(7 << DEVGROUP_SHIFT)
> > > +/* Bit positions in the registers */
> > > +#define DEV_GRP_SHIFT		5
> > > +#define DEV_GRP_MASK		(7 << DEV_GRP_SHIFT)
> > >  #define TYPE_SHIFT		0
> > >  #define TYPE_MASK		(7 << TYPE_SHIFT)
> > >  #define TYPE2_SHIFT		3
> > > @@ -328,7 +328,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
> > >  
> > >  	/* Set resource group */
> > >  	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &grp,
> > > -				rconfig_addr + DEVGROUP_OFFSET);
> > > +				rconfig_addr + DEV_GRP_OFFSET);
> > >  	if (err) {
> > >  		pr_err("TWL4030 Resource %d group could not be read\n",
> > >  			rconfig->resource);
> > > @@ -336,10 +336,10 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
> > >  	}
> > >  
> > >  	if (rconfig->devgroup >= 0) {
> > > -		grp &= ~DEVGROUP_MASK;
> > > -		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
> > > +		grp &= ~DEV_GRP_MASK;
> > > +		grp |= rconfig->devgroup << DEV_GRP_SHIFT;
> > >  		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> > > -					grp, rconfig_addr + DEVGROUP_OFFSET);
> > > +					grp, rconfig_addr + DEV_GRP_OFFSET);
> > >  		if (err < 0) {
> > >  			pr_err("TWL4030 failed to program devgroup\n");
> > >  			return err;
> > > -- 
> > > 1.6.3.3
> > > 
> > 
> > -- 
> > Intel Open Source Technology Centre
> > http://oss.intel.com/
> 
> -- 
> ------------------------------------------------------------
> Amit Kucheria, Finland
> ------------------------------------------------------------

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
