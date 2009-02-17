Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZBRHCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZBRHCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZBRHCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:02:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:40162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZBRHCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:02:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,227,1233561600"; 
   d="scan'208";a="387701239"
Date: Wed, 18 Feb 2009 01:01:35 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 6/7] PCI: document SR-IOV sysfs entries
Message-ID: <20090217170135.GA2520@yzhao-otc.sh.intel.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com> <1234790920-1810-7-git-send-email-yu.zhao@intel.com> <20090217125021.GA2403@yzhao-otc.sh.intel.com> <20090218034910.GA10990@kroah.com> <20090217144303.GA2452@yzhao-otc.sh.intel.com> <20090218062116.GA20081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218062116.GA20081@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 02:21:16PM +0800, Greg KH wrote:
> On Tue, Feb 17, 2009 at 10:43:03PM +0800, Yu Zhao wrote:
> > On Wed, Feb 18, 2009 at 11:49:10AM +0800, Greg KH wrote:
> > > On Tue, Feb 17, 2009 at 08:50:21PM +0800, Yu Zhao wrote:
> > > > I'd like to create a subdirectory under PCI device sysfs directory and
> > > > put some symbol links into that directory (only symbol links). Should I
> > > > use `device' or `kobject'? Currently I use `device' and get two extra
> > > > file/directory (uevent and power) which look like useless for my case
> > > > because this subdirectory doesn't reflect a real device.
> > > 
> > > Neither, just use an attribute group, no new struct device should be
> > > needed at all.
> > 
> > Yes, I was thinking using an attribute group, however, it looks like we
> > can't put symbol link into a group. Maybe I'm wrong, shed some light,
> > please?
> 
> Why would you want a symbolic link in an attribute group?

Sorry I didn't make myself clear. I'd like to create a subdirectory (its
parent is controlled by a `struct device') to only hold symbol links. Can
I use an `attribute group' of the parent `struct device' for this, or a
child `struct device', or a bare `struct kobject'?

Regards,
Yu
