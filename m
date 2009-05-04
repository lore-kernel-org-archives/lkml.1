Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZEDPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZEDPSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZEDPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:17:52 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:36063 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751567AbZEDPRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:17:51 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 11:17:51 EDT
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Karsten Mehrhoff <kawime@gmx.de>
Cc: Shaohua Li <shaohua.li@intel.com>, Dave Airlie <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <op.utd626zcgp7xae@127.0.0.1>
References: <op.us6ywl2jgp7xae@127.0.0.1>
	 <20090430175927.a89f1cd3.akpm@linux-foundation.org>
	 <1241179733.2606.1.camel@localhost.localdomain>
	 <55bc079c-5c3d-465a-be28-0e38c0b48b14@rrsmsx603.amr.corp.intel.com>
	 <20090504014151.GA22872@sli10-desk.sh.intel.com>
	 <op.utd626zcgp7xae@127.0.0.1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 May 2009 17:07:40 +0200
Message-Id: <1241449660.24202.1041.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 08:31 +0200, Karsten Mehrhoff wrote:
> On Mon, 04 May 2009 03:41:51 +0200, Shaohua Li wrote:
> > On Fri, May 01, 2009 at 09:22:19PM +0800, kawime@gmx.de wrote:
> >>> On Thu, 2009-04-30 at 17:59 -0700, Andrew Morton wrote:
> >>>> On Thu, 30 Apr 2009 10:51:47 +0200
> >>>> Karsten Mehrhoff <kawime@gmx.de> wrote:
> >>>>
> >>>>> [1.]
> >>>>> PROBLEM: No more agp card functionality with the patch 2.6.29.2 of
> >>>> 'a/drivers/char/agp/generic.c'
> >>>>>
> >>>>> [2.]
> >>>>> I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run
> >>>> into problems with the speed of my ATI RADEON 9600 (rv350)
> >>>>>
> >>>>
> >>>
> >>> Is your problem speed issue ? ie just a slowdown ? Or does AGP stop
> >>> working with this patch ? Slowdown is expected from this patch but
> >>> it should hurt too much.
> >>>
> >>
> >>                        2.6.29.1  | 2.6.29.2
> >>                         --------  |  --------
> >> glxgears             ~ 2900 FPS  |  ~ 75 FPS
> >> glxgears -fullscreen ~  500 FPS  |  ~ 11 FPS
> > Does this patch alone give so huge slowdown? From my little knowledge,  
> > xserver
> > does agp pages allocation only at startup.
> 
> I only reverted this patch in the source file (/drivers/char/agp/generic.c) and got back my old speed on 2.6.29.2.

Is the DRI enabled in both cases? Compare the Xorg.0.log file and the
output of

dmesg|grep -e agp -e drm


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
