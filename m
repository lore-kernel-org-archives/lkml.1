Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYJVFCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYJVFCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJVFCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:02:00 -0400
Received: from kroah.org ([198.145.64.141]:42955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbYJVFCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:02:00 -0400
Date: Tue, 21 Oct 2008 21:59:38 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (staging/prism2-usb)
Message-ID: <20081022045938.GB11458@kroah.com>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au> <20081021214720.a1ff0096.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021214720.a1ff0096.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:47:20PM -0700, Randy Dunlap wrote:
> On Tue, 21 Oct 2008 19:51:09 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Today's tree will not build for powerpc allyesconfig (libc aborts the
> > link due to a free() problem), sparc(32) defconfig and probably some
> > other configurations.
> > 
> > I am no longer commenting on conflicts that are clearly just caused by
> > slight differences in what has been merged into Linus' tree and
> > linux-next or conflicts caused by further changes in the linux-next after
> > a subset of a tree has been merged.
> 
> 
> ERROR: "wireless_send_event" [drivers/staging/wlan-ng/p80211.ko] undefined!
> 
> Looks like that driver should depend on WIRELESS or slt (something like that).

Hm, I added a WLAN_80211 dependancy here, which should catch this
problem (Ingo reported it a few days ago as well.)

Can you send me the config you used that caused this?

thanks,

greg k-h
