Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYGHO3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYGHO3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYGHO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:28:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27164 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYGHO2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BkQoCfIVzXIjDfSfafQGZklUeVcUnMkmWBKptQy4PqtJp+WEXNUxgmBCNtJZjzsEzZ
         AJsruVsVOC+o22mN0O+8Pk+6+/Jf1hBKNLCMbtKAKg5in45Tgvayw8ppVLgH7lY4EWlG
         AeUWmd0cdvi29YtnToIoZwXxwlhly/5IXVGw8=
Date: Tue, 8 Jul 2008 18:28:23 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 0/3] Genclk: generic framework for clocks managing
	[v3.1]
Message-ID: <20080708142823.GA5590@doriath.ww600.siemens.net>
References: <20080708134242.GA6176@doriath.ww600.siemens.net> <20080708140715.GE24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708140715.GE24620@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 03:07:15PM +0100, Ben Dooks wrote:
> On Tue, Jul 08, 2008 at 05:42:42PM +0400, Dmitry Baryshkov wrote:
> > Hi,
> > 
> > This is again a set of patches to unify the management of clocks and
> > allow easy registration and unregistration of them. This is neccessary
> > to cleanly support such devices as toshiba mobile companion chips,
> > sa1111 companion, ASIC3 companion, etc. Also it brings code unification,
> > especially for a lot of arm sub-arches which share nearly the same code.
> 
> Any particular reason why you've not changed the enable and disable
> methods to one single method taking a bool?

Please read my previous mail. This was specifically requested by Andrew
Morton.

>  
> > Changes from the previous patchset:
> > * Change the name as requested by Ben: clocklib -> generic clk (genclk)
> > * Move from lib/clocklib.c to kernel/genclk/*
> > * Fix locking in generic code
> > 
> > * Rebase PXA patch to the current Russell's tree.
> > * Interlock access to CKEN registers on PXA.
> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'

-- 
With best wishes
Dmitry

