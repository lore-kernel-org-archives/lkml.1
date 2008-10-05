Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYJEDtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYJEDtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 23:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYJEDtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 23:49:49 -0400
Received: from mail.suse.de ([195.135.220.2]:47121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbYJEDtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 23:49:49 -0400
Date: Sat, 4 Oct 2008 20:48:00 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, pchen@nvidia.com, stable@kernel.org
Subject: Re: patch sata_nv-disable-hardreset-for-generic.patch added to
	2.6.26-stable tree
Message-ID: <20081005034800.GA7802@suse.de>
References: <20081001234424.C72C114543E5@imap.suse.de> <200810041827.04721.s.L-H@gmx.de> <20081005025401.GA22549@suse.de> <48E83272.7040709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E83272.7040709@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 12:20:18PM +0900, Tejun Heo wrote:
> Greg KH wrote:
> >>> From 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 Mon Sep 17 00:00:00 2001
> >>> From: Tejun Heo <tj@kernel.org>
> >>> Date: Fri, 29 Aug 2008 16:13:12 +0200
> >>> Subject: sata_nv: disable hardreset for generic
> >>>
> >>> From: Tejun Heo <tj@kernel.org>
> >>>
> >>> commit 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 upstream
> >>>
> >>> of them being unifying probing, hotplug and EH reset paths uniform.
> >>> Previously, broken hardreset could go unnoticed as it wasn't used
> >>> during probing but when something goes wrong or after hotplug the
> >>> problem will surface and bite hard.
> >>>
> >>> OSDL bug 11195 reports that sata_nv generic flavor falls into this
> >>> category.  Hardreset itself succeeds but PHY stays offline after
> >>> hardreset.  I tried longer debounce timing but the result was the
> >>> same.
> >>>
> >>>   http://bugzilla.kernel.org/show_bug.cgi?id=11195
> >>>
> >>> So, it seems we'll have to drop hardreset from the generic flavor.
> >>>
> >>> Signed-off-by: Tejun Heo <tj@kernel.org>
> >>> Cc: Peer Chen <pchen@nvidia.com>
> >>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >> On 2.6.26.5 + the pending stable queue applied, this patch results in lots 
> >> of noise in my syslog (full gzipped dmesg with and without this patch 
> >> attached):
> > 
> > This patch has been removed from the stable queue, so it shouldn't be an
> > issue anymore, right?
> 
> It's currently a mess.  Please take a look at the following message for
> the whole story.
> 
>   http://article.gmane.org/gmane.linux.ide/34942
> 
> It's interesting how they fixed hardreset of the chipset step-by-step. :-(

Ick, you are right, what a mess.

Do you want that patch in 2.6.26-stable now?  Or just don't worry about
it?

thanks,

greg k-h
