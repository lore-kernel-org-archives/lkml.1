Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbYGBIaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbYGBIaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYGBIaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:30:05 -0400
Received: from trinity.fluff.org ([89.145.97.151]:55632 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYGBIaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:30:03 -0400
Date: Wed, 2 Jul 2008 09:29:54 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [-mmotm] some different buliding failures
Message-ID: <20080702082954.GP8489@trinity.fluff.org>
References: <486B1EE0.9060303@cn.fujitsu.com> <20080702010212.7b4b9301.akpm@linux-foundation.org> <20080702082021.GA1327@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702082021.GA1327@linux-sh.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 05:20:21PM +0900, Paul Mundt wrote:
> On Wed, Jul 02, 2008 at 01:02:12AM -0700, Andrew Morton wrote:
> > On Wed, 02 Jul 2008 14:23:28 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > drivers/mfd/sm501.c:39: error: field 'gpio' has incomplete type
> > > 
> > 
> > Ben, can you please take a look?  I suspect the fix is to disable this
> > driver on x86.
> > 
> Note that there are SM501 PCI cards that are architecture independent..

The best fix would be to enable the gpiolib[1] for x86. I agree the
changes to ensure it builds with gpio turned off where incomplete. I'll
re-issue these as soon as possible.

[1] why is this a library anyway? it isn't as if you can export it to use
    in other projects, and the choice is gpiolib or nothing.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

