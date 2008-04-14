Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbYDNPMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbYDNPMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbYDNPMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:12:33 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9366 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761936AbYDNPMb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:12:31 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JZBM8C-02-BKX-01
Date: Mon, 14 Apr 2008 09:18:56 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: OLPC: gxfb/lxfb: add DCON panel modes to framebuffer drivers
Message-ID: <20080414151856.GA10111@cosmic.amd.com>
References: <20080414035302.794dcd7a@ephemeral> <200804141033.59998.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200804141033.59998.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 14 Apr 2008 15:12:20.0209 (UTC) FILETIME=[EF21C610:01C89E41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/08 10:33 +0200, Arnd Bergmann wrote:
> On Monday 14 April 2008, Andres Salomon wrote:
> > Since there's no way to autodetect panel modes, we're forced to hardcode
> > them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
> > specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> 
> Since the XO is based on Open Firmware, shouldn't the panel size really be
> a property in the device tree that can be read by this driver?

Andre's description was slightly misleading.  We could probably detect
the panel mode, but there isn't any reason to since the panel timings
are well known and won't change.  While OFW detection would be good
computer science fu, it would be a wasted effort since its so easy to hard
code them into the table.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

