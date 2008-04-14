Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYDNPbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYDNPbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYDNPb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:31:28 -0400
Received: from mail.queued.net ([207.210.101.209]:1560 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYDNPb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:31:28 -0400
Date: Mon, 14 Apr 2008 11:33:33 -0400
From: Andres Salomon <dilinger@queued.net>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: OLPC: gxfb/lxfb: add DCON panel modes to framebuffer drivers
Message-ID: <20080414113333.2ce51648@ephemeral>
In-Reply-To: <20080414151856.GA10111@cosmic.amd.com>
References: <20080414035302.794dcd7a@ephemeral>
	<200804141033.59998.arnd@arndb.de>
	<20080414151856.GA10111@cosmic.amd.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 09:18:56 -0600
Jordan Crouse <jordan.crouse@amd.com> wrote:

> On 14/04/08 10:33 +0200, Arnd Bergmann wrote:
> > On Monday 14 April 2008, Andres Salomon wrote:
> > > Since there's no way to autodetect panel modes, we're forced to hardcode
> > > them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
> > > specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.
> > > 
> > > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > 
> > Since the XO is based on Open Firmware, shouldn't the panel size really be
> > a property in the device tree that can be read by this driver?
> 
> Andre's description was slightly misleading.  We could probably detect
> the panel mode, but there isn't any reason to since the panel timings
> are well known and won't change.  While OFW detection would be good
> computer science fu, it would be a wasted effort since its so easy to hard
> code them into the table.
> 
> Jordan
> 

Right, that's what I get for sending this stuff out at 4am.  To be clear,
the issue that we have to hard code ways to access panel timing info on a
per-platform and/or per-bios basis.  There's no standard way to fetch
it across all Geodes (that I'm aware of).  Even the VSA doesn't really
help us here.



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
