Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbZLPO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbZLPO73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbZLPO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:59:25 -0500
Received: from kroah.org ([198.145.64.141]:39474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZLPO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:59:24 -0500
Date: Wed, 16 Dec 2009 06:55:52 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Message-ID: <20091216145552.GA25983@kroah.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
 <20091215041500.GB31200@kroah.com>
 <4B273479.6050502@canonical.com>
 <20091215134943.GA11667@kroah.com>
 <20091215163100.GC8097@tuxdriver.com>
 <1260906168.9623.4.camel@rc-desk>
 <20091215194938.GA13297@kroah.com>
 <4B288232.4060901@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B288232.4060901@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 02:46:10PM +0800, Ike Panhc wrote:
> Greg KH wrote:
> > On Tue, Dec 15, 2009 at 11:42:48AM -0800, reinette chatre wrote:
> >> On Tue, 2009-12-15 at 08:31 -0800, John W. Linville wrote:
> >>> On Tue, Dec 15, 2009 at 05:49:43AM -0800, Greg KH wrote:
> >>>> On Tue, Dec 15, 2009 at 03:02:17PM +0800, Ike Panhc wrote:
> >>>>> Please consider applying to linux-2.6.31.y
> >>>> I need the subsystem maintainer to agree with this, have they?
> >>> It seems fine to me.  You may want to let Intel comment too.
> >>>
> >> No objection here. Even so, I find it strange that this patch fixes a
> >> problem since it really should not have any functional changes. 
> > 
> > Ok, if there is no functional change, why is this needed?
> > 
> > Ike?
> > 
> > thanks,
> > 
> > greg k-h
> I review the patch again. Yes, it is no functional change. Sorry I have
> misunderstanding about the patch. Please do not put the second patch into
> stable.

Ok, will do.

> But Please consider applying the first patch (change IWL6000_UCODE_API_MAX
> to v4) to 2.6.31-stable tree. It will be good to use v4 firmware on iwl6000.

Why, what bug does it fix?  Will it require users to update their
firmware versions on their system as well?

thanks,

greg k-h
