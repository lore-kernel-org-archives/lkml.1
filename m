Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986Ab0AQPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0AQPiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887Ab0AQPh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:37:59 -0500
Received: from kroah.org ([198.145.64.141]:50533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0AQPh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:37:58 -0500
Date: Sat, 16 Jan 2010 19:23:19 -0800
From: Greg KH <greg@kroah.com>
To: Ozan ??a??layan <ozan@pardus.org.tr>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [0/9] 2.6.31.12-stable review
Message-ID: <20100117032319.GA27413@kroah.com>
References: <20100114224848.GA532@kroah.com> <4B520D98.7030202@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B520D98.7030202@pardus.org.tr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 09:03:52PM +0200, Ozan ??a??layan wrote:
> Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.31.12 release.
> > There are 9 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> 
> Hi Greg,
> 
> 1. There's this "mce: native_apic_write_dummy()" WARNING which causes governor failures on
> some of systems.
> http://bugzilla.kernel.org/show_bug.cgi?id=14521
> 
> Here's what I wrote in the last comment of the bug:
> 
> The following 2 commits from linux-2.6 fixes the issue on 2.6.31.11 on my
> system. I think they should at least be sent to stable@kernel.org for 2.6.32.y
> inclusion if they are the correct/complete fixes:
> 
> >From 485a2e1973fd9f98c2c6776e66ac4721882b69e0 Mon Sep 17 00:00:00 2001
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Date: Mon, 14 Dec 2009 17:56:34 +0900
> Subject: [PATCH] x86, mce: Thermal monitoring depends on APIC being enabled
> 
> >From 70fe440718d9f42bf963c2cffe12008eb5556165 Mon Sep 17 00:00:00 2001
> From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Date: Mon, 14 Dec 2009 17:57:00 +0900
> Subject: [PATCH] x86, mce: Clean up thermal init by introducing
> intel_thermal_supported()

I'll review them for the next round of .32 patches.

> 2. Boot hangs on old AMD Athlon XP Processors (not 64, not X2) with CONFIG_X86_CPU_DEBUG enabled kernels:
> http://groups.google.com/group/linux.kernel/browse_thread/thread/34ca6dd8aeab02b3/0c0acb9d6437756f?lnk=raot&fwc=1
> 
> Reverting the following commit fixes the problem:
> 
> >From 5095f59bda6793a7b8f0856096d6893fe98e0e51 Mon Sep 17 00:00:00 2001
> From: Jaswinder Singh Rajput <jaswin...@kernel.org>
> Date: Fri, 5 Jun 2009 23:27:17 +0530
> Subject: [PATCH] x86: cpu_debug: Remove model information to reduce encoding-decoding
> 
> Remove model information, encoding/decoding and reduce bookkeeping.
> 
> This, besides removing a lot of code and cleaning up the code, also
> enables these features on many more CPUs that were enumerated before. 

As this is going to be the last .31 release, and all users should really
be moving to .32, I'm not going to worry about this one.  Is that ok
with you?

thanks,

greg k-h
