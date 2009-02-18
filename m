Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZBRGtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZBRGtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 01:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZBRGtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 01:49:07 -0500
Received: from kroah.org ([198.145.64.141]:47861 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751754AbZBRGtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 01:49:06 -0500
Date: Tue, 17 Feb 2009 22:21:16 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 6/7] PCI: document SR-IOV sysfs entries
Message-ID: <20090218062116.GA20081@kroah.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com> <1234790920-1810-7-git-send-email-yu.zhao@intel.com> <20090217125021.GA2403@yzhao-otc.sh.intel.com> <20090218034910.GA10990@kroah.com> <20090217144303.GA2452@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217144303.GA2452@yzhao-otc.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:43:03PM +0800, Yu Zhao wrote:
> On Wed, Feb 18, 2009 at 11:49:10AM +0800, Greg KH wrote:
> > On Tue, Feb 17, 2009 at 08:50:21PM +0800, Yu Zhao wrote:
> > > Hi Greg,
> > > 
> > > The `struct device' is preferred over the `struct kobject' in all cases
> > > that create subdirectory in sysfs, is this true?
> > 
> > If you have a parent directory being controlled by a struct device, yes.
> 
> Thanks! Do we need to document this somewhere?

Probably, patches gladly accepted for documentation fixes/updates :)

> > > I'd like to create a subdirectory under PCI device sysfs directory and
> > > put some symbol links into that directory (only symbol links). Should I
> > > use `device' or `kobject'? Currently I use `device' and get two extra
> > > file/directory (uevent and power) which look like useless for my case
> > > because this subdirectory doesn't reflect a real device.
> > 
> > Neither, just use an attribute group, no new struct device should be
> > needed at all.
> 
> Yes, I was thinking using an attribute group, however, it looks like we
> can't put symbol link into a group. Maybe I'm wrong, shed some light,
> please?

Why would you want a symbolic link in an attribute group?

confused,

greg k-h
