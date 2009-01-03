Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZACJWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZACJWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 04:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZACJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 04:22:26 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:46240 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZACJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 04:22:24 -0500
Date: Sat, 3 Jan 2009 04:21:42 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Eric Anholt <eric@anholt.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: worth submitting a detailed EDID structure?
In-Reply-To: <1230936956.6095.5.camel@gaiman.anholt.net>
Message-ID: <alpine.LFD.2.00.0901030421150.16954@localhost.localdomain>
References: <alpine.LFD.2.00.0901020906310.12465@localhost.localdomain> <1230936956.6095.5.camel@gaiman.anholt.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Eric Anholt wrote:

> On Fri, 2009-01-02 at 09:08 -0500, Robert P. J. Day wrote:
> > just noticed the header file include/video/edid.h, which defines
> > video EDID info as simply:
> >
> >   struct edid_info {
> >         unsigned char dummy[128];
> >   };
> >
> > a couple months back, i had to mess with EDID info and defined a
> > detailed structure to manipulate EDID fields.  is it worth
> > submitting that as a patch and union'ing that with the above?
> > not a big deal for me either way.
>
> The KMS code already has detailed EDID structures in drm_edid.h, for
> what it's worth.  We still need to get CEA extension bits ported
> over, though.

  ah, i hadn't noticed that.  eggcellent, thanks.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
