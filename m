Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZLONyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZLONyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbZLONyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:54:38 -0500
Received: from kroah.org ([198.145.64.141]:42420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760201AbZLONyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:54:37 -0500
Date: Tue, 15 Dec 2009 05:49:43 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
       stable@kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Message-ID: <20091215134943.GA11667@kroah.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
 <20091215041500.GB31200@kroah.com>
 <4B273479.6050502@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B273479.6050502@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 03:02:17PM +0800, Ike Panhc wrote:
> Greg KH wrote:
> > On Tue, Dec 15, 2009 at 11:45:10AM +0800, Ike Panhc wrote:
> >> This patch unifies setup_rxon_timing funcions
> >> of AGN and 3945. HWs differ only in supported maximal
> >> beacon interval. This is reflected in hw_paras.max_beacon_itrvl
> >>
> >> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> >> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >> (cherry picked from commit 2c2f3b33888419fb9e7d015b9dc67b9db4437efa)
> >>
> >> Conflicts:
> >>
> >> 	drivers/net/wireless/iwlwifi/iwl-dev.h
> > 
> > What does this mean?
> > 
> After cherry-pick:
> 
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@@ -625,7 -608,7 +625,11 @@@ struct iwl_hw_params 
> 	u8  max_stations;
> 	u8  bcast_sta_id;
> 	u8 fat_channel;
> ++<<<<<<< HEAD:drivers/net/wireless/iwlwifi/iwl-dev.h
>  +	u8 sw_crypto;
> ++=======
> +	u8  max_beacon_itrvl;   /* in 1024 ms */
> ++>>>>>>> 2c2f3b3... iwlwifi: unify iwl_setup_rxon_timing:drivers/net/wireless/iwlwifi/iwl-dev.h
> 	u32 max_inst_size;
> 	u32 max_data_size;
> 	u32 max_bsm_size;
> 
> The sw_crypto is removed in the prior commit (90e8e4), and the commit
> is not in the stable tree. We still need sw_crypto.
> 
> So, the patch is modified to keep sw_crypto.

And why would we care?  We've never used this kind of marking before in
the kernel changelogs that I know of.

> >> CC: stable@kernel.org
> >> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> >>
> >> BugLink: http://bugs.launchpad.net/bugs/496496
> > 
> > What are you expecting this patch to be applied to?
> > 
> > confused,
> Please consider applying to linux-2.6.31.y

I need the subsystem maintainer to agree with this, have they?

thanks,

greg k-h
