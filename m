Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZLZRMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZLZRMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 12:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZLZRMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 12:12:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50532 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZLZRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 12:12:05 -0500
Date: Sat, 26 Dec 2009 18:12:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       DSA <debian-admin@lists.debian.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.32.1: BUG and panic: unable to handle kernel NULL pointer
	dereference at 000000000000001f
Message-ID: <20091226171202.GB10256@basil.fritz.box>
References: <20091215162736.GS13850@anguilla.noreply.org> <871vindxkv.fsf@basil.nowhere.org> <20091222183354.GM13850@anguilla.noreply.org> <20091222185758.GN13850@anguilla.noreply.org> <20091224130425.GW13850@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224130425.GW13850@anguilla.noreply.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 02:04:25PM +0100, Peter Palfrader wrote:
> On Tue, 22 Dec 2009, Peter Palfrader wrote:
> 
> > On Tue, 22 Dec 2009, Peter Palfrader wrote:
> > 
> > > > If that doesn't help perhaps disable CONFIG_HID_GYRATION,
> > > > but from your other oops something more seems to be broken anyways.
> > > 
> > > This is a static kernel - no module support.  Anyway, I also tried
> > > without CONFIG_USB_HID (which pulls in all the other HID_* things) but
> > > no luck.
> > 
> > However, disabling all of HID (CONFIG_HID_SUPPORT=n) makes the system
> > boot (Previously HID, HIDRAW and HID_SUPPORT were still enabled).

It's suspicious if you don't have such devices, that would
point to something being confused in the driver probing 
layer.

> 
> However, I still see panics on boot occassionally, tho not so often or
> reproducible.  So far only on dl385 (opteron) systems.

Multiple systems and the same oopses?

> 
> And all of the backtraces go through sysfs_new_dirent() near the top.

Please post full oopses.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
