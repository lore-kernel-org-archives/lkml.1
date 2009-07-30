Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZG3MMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZG3MMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZG3MMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:12:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:44715 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751459AbZG3MMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:12:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qsFcVTo/qjDvSl3JTZgGmP9XgDdJe7EXI1x3KF1
	tqCJZnQMu12R/6
Subject: [rt2800 doesn't authenticate (wpapsk/tkip)] Re: [wireless]
 rt2870sta BUGs on shutdown, 2.6.30.2->git.today+git.wireless.today
From: Mike Galbraith <efault@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248948326.8823.4.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 14:11:56 +0200
Message-Id: <1248955916.7995.47.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 12:05 +0200, Mike Galbraith wrote:
> On Thu, 2009-07-30 at 11:55 +0200, Johannes Berg wrote:
> > On Thu, 2009-07-30 at 11:44 +0200, Mike Galbraith wrote:
> > > On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
> > > > On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
> > > > 
> > > > > drivers/staging/rt2870/../rt2860/sta_ioctl.c
> > > > 
> > > > Sorry, but that '/staging/' thing in there means we cannot support this.
> > > > If you must, take your query to the staging list,
> > > > devel@driverdev.osuosl.org (according to MAINTAINERS).
> > > 
> > > Forwarded, thanks.
> > > 
> > > ....hm.  Does "If you must" mean reports aren't welcome?
> > 
> > To be honest, I don't know. I'd rather see people use the rt2x00 code
> > instead of spending time cleaning up that mess (the code you've pasted
> > was pretty bad!). But you may or may not find somebody who cares about
> > that, just rather unlikely on this list.
> 
> Understood (and yeah, the source is.. not pretty).  Sorry for the noise.
> 
> WRT rt2x00 with this adapter, I tried it, was a nogo.  If I find time,
> I'll reconfigure/report.

This is nogo with rt2x00 driver fwiw.  Maybe some simple configuration
thing, but I'm having no luck getting the bugger to work.

[   12.942335] phy0: Selected rate control algorithm 'minstrel'
[   12.942440] Registered led device: rt2800usb-phy0::radio
[   12.955279] Registered led device: rt2800usb-phy0::assoc
[   12.968003] Registered led device: rt2800usb-phy0::quality
[   12.981183] usbcore: registered new interface driver rt2800usb

[   33.032056] rt2800usb 1-5:1.0: firmware: requesting rt2870.bin
[   33.161552] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.0/input/input4
[   33.347130] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   34.513078] eth0: no IPv6 routers present
[   35.935289] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   35.937306] wlan0: authenticated
[   35.937309] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   35.942551] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   35.942555] wlan0: associated
[   35.950948] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   37.314470] mtrr: base(0xd0000000) is not aligned on a size(0xff00000) boundary
[   39.937271] wlan0: deauthenticated (Reason: 1)
[   40.936521] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   40.939152] wlan0 direct probe responded
[   40.939155] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   40.941145] wlan0: authenticated
[   40.941148] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   40.945904] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   40.945909] wlan0: associated
[   44.947499] wlan0: deauthenticated (Reason: 1)
[   45.944034] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   45.946623] wlan0 direct probe responded
[   45.946627] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   45.948744] wlan0: authenticated
[   45.948747] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   45.953996] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   45.953999] wlan0: associated
[   46.376015] wlan0: no IPv6 routers present
[   49.947986] wlan0: deauthenticated (Reason: 1)
[   50.944545] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   50.947230] wlan0 direct probe responded
[   50.947234] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   50.949219] wlan0: authenticated
[   50.949222] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   50.954473] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   50.954477] wlan0: associated
[   54.958220] wlan0: deauthenticated (Reason: 1)
[   55.956527] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   55.959137] wlan0 direct probe responded
[   55.959140] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   55.961123] wlan0: authenticated
[   55.961126] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   55.966502] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   55.966505] wlan0: associated
[   59.968460] wlan0: deauthenticated (Reason: 1)
[   60.968032] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   60.970625] wlan0 direct probe responded
[   60.970628] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   60.972741] wlan0: authenticated
[   60.972743] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   60.978499] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   60.978502] wlan0: associated
[   64.978212] wlan0: deauthenticated (Reason: 1)
[   65.976524] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   65.979117] wlan0 direct probe responded
[   65.979119] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   65.981120] wlan0: authenticated
[   65.981124] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   65.986501] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   65.986505] wlan0: associated
[   69.988830] wlan0: deauthenticated (Reason: 1)
[   70.988546] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   70.991121] wlan0 direct probe responded
[   70.991124] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   70.993237] wlan0: authenticated
[   70.993239] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   70.998494] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   70.998498] wlan0: associated
[   74.998070] wlan0: deauthenticated (Reason: 1)
[   75.996510] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   75.999123] wlan0 direct probe responded
[   75.999127] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   76.001239] wlan0: authenticated
[   76.001242] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   76.006745] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   76.006749] wlan0: associated
[   80.007943] wlan0: deauthenticated (Reason: 1)
[   81.008508] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   81.011115] wlan0 direct probe responded
[   81.011118] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   81.013111] wlan0: authenticated
[   81.013115] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   81.018494] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   81.018498] wlan0: associated
[   85.017825] wlan0: deauthenticated (Reason: 1)
[   86.016508] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   86.019115] wlan0 direct probe responded
[   86.019118] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   86.021230] wlan0: authenticated
[   86.021233] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   86.026610] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   86.026613] wlan0: associated
[   96.027614] wlan0: disassociating by local choice (reason=3)
[   96.030483] wlan0: deauthenticated (Reason: 6)
[   97.485736] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   97.487617] wlan0: authenticated
[   97.487620] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   97.492871] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   97.492875] wlan0: associated
[  101.487940] wlan0: deauthenticated (Reason: 1)
[  102.484011] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  102.486625] wlan0 direct probe responded
[  102.486629] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  102.488742] wlan0: authenticated
[  102.488746] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  102.493993] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  102.493996] wlan0: associated
[  112.496478] wlan0: disassociating by local choice (reason=3)
[  112.499359] wlan0: deauthenticated (Reason: 6)
[  123.951239] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  123.953248] wlan0: authenticated
[  123.953252] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  123.958499] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  123.958503] wlan0: associated
[  127.957566] wlan0: deauthenticated (Reason: 1)
[  128.956012] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  128.958616] wlan0 direct probe responded
[  128.958619] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  128.960743] wlan0: authenticated
[  128.960746] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  128.966121] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  128.966125] wlan0: associated
[  132.967815] wlan0: deauthenticated (Reason: 1)
[  133.964011] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  133.966613] wlan0 direct probe responded
[  133.966616] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  133.968740] wlan0: authenticated
[  133.968744] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  133.973868] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  133.973871] wlan0: associated
[  137.967813] wlan0: deauthenticated (Reason: 1)
[  138.964014] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  138.966613] wlan0 direct probe responded
[  138.966616] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  138.968738] wlan0: authenticated
[  138.968741] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  138.973996] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  138.973999] wlan0: associated
[  142.967685] wlan0: deauthenticated (Reason: 1)
[  143.964009] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  143.966609] wlan0 direct probe responded
[  143.966612] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  143.968736] wlan0: authenticated
[  143.968740] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  143.973988] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  143.973991] wlan0: associated
[  147.967736] wlan0: deauthenticated (Reason: 1)
[  148.964016] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  148.966607] wlan0 direct probe responded
[  148.966609] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  148.968734] wlan0: authenticated
[  148.968736] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  148.973983] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  148.973985] wlan0: associated
[  152.967813] wlan0: deauthenticated (Reason: 1)
[  153.964009] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  154.164015] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 2
[  154.364015] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 3
[  154.564009] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 timed out
[  181.899242] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  182.096012] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 2
[  182.296011] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 3
[  182.496011] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 timed out
[  200.602027] usbcore: deregistering interface driver rt2800usb


