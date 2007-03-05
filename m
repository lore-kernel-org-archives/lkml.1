Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbXCELp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbXCELp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933188AbXCELp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:45:29 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:60762 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbXCELp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:45:28 -0500
Subject: Re: [1/6] 2.6.21-rc2: known regressions
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: Mark Lord <lkml@rtr.ca>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070305043443.GA29158@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015031.GF3441@stusta.de> <45EB961D.6030808@rtr.ca>
	 <20070305043443.GA29158@kroah.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 13:42:04 +0100
Message-Id: <1173098524.6638.19.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > >Subject    : Bluetooth RFComm locks up the machine  (device_move() related)
> > >References : http://lkml.org/lkml/2007/3/4/64
> > >Submitter  : Mark Lord <lkml@rtr.ca>
> > >Caused-By  : Marcel Holtmann <marcel@holtmann.org>
> > >             commit c1a3313698895d8ad4760f98642007bf236af2e8
> > >Status     : unknown
> > 
> > A 2-line patch exists for fs/sysfs/dir.c to address this.
> > Waiting on Greg to apply it or substitute something prettier.  ;)
> 
> I want to see if Marcel agrees with it, as he did the original patch in
> that area.

I am not deep enough in the sysfs code to tell you if Mark's change it
correct or not. It looks however fully reasonable to me. From the higher
level perspective of the device_move() usage the RFCOMM code looks
correct and has been tested before I submitted it for inclusion.

Regards

Marcel


