Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653Ab0ASXNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0ASXNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534Ab0ASXNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:13:08 -0500
Received: from kroah.org ([198.145.64.141]:40815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0ASXNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:13:06 -0500
Date: Tue, 19 Jan 2010 15:02:53 -0800
From: Greg KH <greg@kroah.com>
To: Ozan ??a??layan <ozan@pardus.org.tr>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable-review@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [0/9] 2.6.31.12-stable review
Message-ID: <20100119230253.GC4034@kroah.com>
References: <20100114224848.GA532@kroah.com>
 <4B520D98.7030202@pardus.org.tr>
 <20100117032319.GA27413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117032319.GA27413@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 07:23:19PM -0800, Greg KH wrote:
> On Sat, Jan 16, 2010 at 09:03:52PM +0200, Ozan ??a??layan wrote:
> > Greg KH wrote:
> > > This is the start of the stable review cycle for the 2.6.31.12 release.
> > > There are 9 patches in this series, all will be posted as a response to
> > > this one.  If anyone has any issues with these being applied, please let
> > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > 
> > Hi Greg,
> > 
> > 1. There's this "mce: native_apic_write_dummy()" WARNING which causes governor failures on
> > some of systems.
> > http://bugzilla.kernel.org/show_bug.cgi?id=14521
> > 
> > Here's what I wrote in the last comment of the bug:
> > 
> > The following 2 commits from linux-2.6 fixes the issue on 2.6.31.11 on my
> > system. I think they should at least be sent to stable@kernel.org for 2.6.32.y
> > inclusion if they are the correct/complete fixes:
> > 
> > >From 485a2e1973fd9f98c2c6776e66ac4721882b69e0 Mon Sep 17 00:00:00 2001
> > From: Cyrill Gorcunov <gorcunov@openvz.org>
> > Date: Mon, 14 Dec 2009 17:56:34 +0900
> > Subject: [PATCH] x86, mce: Thermal monitoring depends on APIC being enabled
> > 
> > >From 70fe440718d9f42bf963c2cffe12008eb5556165 Mon Sep 17 00:00:00 2001
> > From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> > Date: Mon, 14 Dec 2009 17:57:00 +0900
> > Subject: [PATCH] x86, mce: Clean up thermal init by introducing
> > intel_thermal_supported()
> 
> I'll review them for the next round of .32 patches.

The first looks ok, and I've queued it up for the next .32 release.  The
second one only moves code around, and does nothing, so I don't think it
is needed.

thanks,

greg k-h
