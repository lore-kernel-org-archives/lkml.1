Return-Path: <linux-kernel-owner+w=401wt.eu-S934586AbZLQDaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586AbZLQDaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbZLQD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:29:59 -0500
Received: from kroah.org ([198.145.64.141]:41331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbZLQD37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:29:59 -0500
Date: Wed, 16 Dec 2009 19:29:25 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: reinette chatre <reinette.chatre@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Message-ID: <20091217032925.GA21374@kroah.com>
References: <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
 <20091215041500.GB31200@kroah.com>
 <4B273479.6050502@canonical.com>
 <20091215134943.GA11667@kroah.com>
 <20091215163100.GC8097@tuxdriver.com>
 <1260906168.9623.4.camel@rc-desk>
 <20091215194938.GA13297@kroah.com>
 <4B288232.4060901@canonical.com>
 <1260983101.9623.11.camel@rc-desk>
 <4B298ECF.7050009@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B298ECF.7050009@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:52:15AM +0800, Ike Panhc wrote:
> reinette chatre wrote:
> > On Tue, 2009-12-15 at 22:46 -0800, Ike Panhc wrote:
> > 
> >> But Please consider applying the first patch (change IWL6000_UCODE_API_MAX
> >> to v4) to 2.6.31-stable tree. It will be good to use v4 firmware on iwl6000.
> > 
> > Please no. This will effectively enable 6000 series in 2.6.31. We did
> > not target 2.6.31 for 6000 series enabling and more patches, which are
> > in 2.6.32, are required for 6000 series to work well.
> > 
> > Reinette
> > 
> Got it, so backport any patch for iwl6000 to 2.6.31-stable is not reasonable.

Bugfixes are fine, but that is not what this is.

Please go read the file, Documentation/stable_kernel_rules.txt to give
you an idea of what we are expecting here.

thanks,

greg k-h
