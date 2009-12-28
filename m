Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbZL1B1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbZL1B1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZL1B1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:27:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:16310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbZL1B1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:27:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227014956"
Subject: Re: lvds downclocking breaks on G45/thinkpad T500
From: ykzhao <yakui.zhao@intel.com>
To: Andres Freund <andres@anarazel.de>
Cc: David Airlie <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Adam Jackson <ajax@redhat.com>
In-Reply-To: <200912271518.57886.andres@anarazel.de>
References: <200912261749.30839.andres@anarazel.de>
	 <200912261841.55828.andres@anarazel.de>
	 <1261919455.4499.31.camel@localhost.localdomain>
	 <200912271518.57886.andres@anarazel.de>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Mon, 28 Dec 2009 09:24:48 +0800
Message-Id: <1261963488.4499.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-27 at 22:18 +0800, Andres Freund wrote:
> On Sunday 27 December 2009 14:10:55 ykzhao wrote:
> > On Sun, 2009-12-27 at 01:41 +0800, Andres Freund wrote:
> > > On Saturday 26 December 2009 17:49:29 Andres Freund wrote:
> > > > On 2.6.33-rc1 I noticed that the display of my T500 with a G45 reacts
> > > > very slowly (you can see the text appearing) and colors take a time to
> > > > "solidify". I.e. making a white terminal black takes some seconds. ...
> > > > Anything I can do to help analyzing the issue?
> > >
> > > Thats with recent git checkouts of xorg btw, if thats relevant (which I
> > > doubt a bit).
> > >
> > > The missing config is attached now as well.
> > 
> > It will be great if you can open a new bug on
> > bugs.freedesktop.org(Product=xorg, component = driver/intel) and attach
> > the following info:
> >     1. add the boot option of "drm.debug=0x06" and attach the output of
> > dmesg.
> >     2. attach the output of "xrandr -q --verbose"
> >     3. attach the vbios.dump, which can be obtained by using the
> > following command:
> >         echo 1 > /sys/devices/pci0000:00/0000:00:02.0/rom
> >         cat /sys/devices/pci0000:00/0000:00:02.0/rom
> >     4. attach the output of Xorg.0.log
> Is it relevant whether I boot a kernel with the patch really enabled?

I don't know whether it is relevant with my patch. In fact my patch only
checks whether the LVDS downclock is found and then set the
corresponding flag. 

Anyway, please open a new bug and I will investigate it.

thanks.
   Yakui
> 
> Andres

