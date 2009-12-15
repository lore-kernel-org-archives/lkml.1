Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbZLOQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbZLOQeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbZLOQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:34:16 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60941 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435AbZLOQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:34:16 -0500
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>, stable@kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>
In-Reply-To: <20091215134943.GA11667@kroah.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
	 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
	 <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com>
	 <20091215134943.GA11667@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 08:34:00 -0800
Message-Id: <1260894840.4041.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > >> This patch unifies setup_rxon_timing funcions
> > >> of AGN and 3945. HWs differ only in supported maximal
> > >> beacon interval. This is reflected in hw_paras.max_beacon_itrvl
> > >>
> > >> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > >> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > >> (cherry picked from commit 2c2f3b33888419fb9e7d015b9dc67b9db4437efa)
> > >>
> > >> Conflicts:
> > >>
> > >> 	drivers/net/wireless/iwlwifi/iwl-dev.h
> > > 
> > > What does this mean?
> > > 
> > After cherry-pick:
> > 
> > --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> > +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> > @@@ -625,7 -608,7 +625,11 @@@ struct iwl_hw_params 
> > 	u8  max_stations;
> > 	u8  bcast_sta_id;
> > 	u8 fat_channel;
> > ++<<<<<<< HEAD:drivers/net/wireless/iwlwifi/iwl-dev.h
> >  +	u8 sw_crypto;
> > ++=======
> > +	u8  max_beacon_itrvl;   /* in 1024 ms */
> > ++>>>>>>> 2c2f3b3... iwlwifi: unify iwl_setup_rxon_timing:drivers/net/wireless/iwlwifi/iwl-dev.h
> > 	u32 max_inst_size;
> > 	u32 max_data_size;
> > 	u32 max_bsm_size;
> > 
> > The sw_crypto is removed in the prior commit (90e8e4), and the commit
> > is not in the stable tree. We still need sw_crypto.
> > 
> > So, the patch is modified to keep sw_crypto.
> 
> And why would we care?  We've never used this kind of marking before in
> the kernel changelogs that I know of.
> 
> > >> CC: stable@kernel.org
> > >> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> > >>
> > >> BugLink: http://bugs.launchpad.net/bugs/496496
> > > 
> > > What are you expecting this patch to be applied to?
> > > 
> > > confused,
> > Please consider applying to linux-2.6.31.y
> 
> I need the subsystem maintainer to agree with this, have they?

I agree here. Not copying Reinette on this is just wrong. And blindly
picking some patches and sending them for -stable even more.

Regards

Marcel


