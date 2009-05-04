Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZEDBmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZEDBmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 21:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZEDBly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 21:41:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:55963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZEDBlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 21:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,289,1239001200"; 
   d="scan'208";a="138739676"
Date: Mon, 4 May 2009 09:41:51 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "kawime@gmx.de" <kawime@gmx.de>
Cc: Jerome Glisse <glisse@freedesktop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, "stable@kernel.org" <stable@kernel.org>
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
Message-ID: <20090504014151.GA22872@sli10-desk.sh.intel.com>
References: <op.us6ywl2jgp7xae@127.0.0.1> <20090430175927.a89f1cd3.akpm@linux-foundation.org> <1241179733.2606.1.camel@localhost.localdomain> <55bc079c-5c3d-465a-be28-0e38c0b48b14@rrsmsx603.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55bc079c-5c3d-465a-be28-0e38c0b48b14@rrsmsx603.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:22:19PM +0800, kawime@gmx.de wrote:
> > On Thu, 2009-04-30 at 17:59 -0700, Andrew Morton wrote:
> >> On Thu, 30 Apr 2009 10:51:47 +0200
> >> Karsten Mehrhoff <kawime@gmx.de> wrote:
> >>
> >>> [1.]
> >>> PROBLEM: No more agp card functionality with the patch 2.6.29.2 of  
> >> 'a/drivers/char/agp/generic.c'
> >>>
> >>> [2.]
> >>> I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run  
> >> into problems with the speed of my ATI RADEON 9600 (rv350)
> >>>
> >>
> >
> > Is your problem speed issue ? ie just a slowdown ? Or does AGP stop
> > working with this patch ? Slowdown is expected from this patch but
> > it should hurt too much.
> >
> 
>                         2.6.29.1  | 2.6.29.2
>                         --------  |  --------
> glxgears             ~ 2900 FPS  |  ~ 75 FPS
> glxgears -fullscreen ~  500 FPS  |  ~ 11 FPS
Does this patch alone give so huge slowdown? From my little knowledge, xserver
does agp pages allocation only at startup.
