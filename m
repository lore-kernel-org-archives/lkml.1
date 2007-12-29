Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXL2Jxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXL2Jxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXL2Jxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:53:41 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36046 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXL2Jxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:53:41 -0500
Date: Sat, 29 Dec 2007 11:53:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
Message-ID: <20071229095326.GD27360@does.not.exist>
References: <20071229084846.GA27360@does.not.exist> <20071229.005408.76652528.davem@davemloft.net> <20071229090619.GB27360@does.not.exist> <20071229.011802.76136568.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071229.011802.76136568.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 01:18:02AM -0800, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Sat, 29 Dec 2007 11:06:19 +0200
> 
> > On Sat, Dec 29, 2007 at 12:54:08AM -0800, David Miller wrote:
> > > From: Adrian Bunk <bunk@kernel.org>
> > > Date: Sat, 29 Dec 2007 10:48:46 +0200
> > > 
> > > > On Sat, Dec 29, 2007 at 12:14:11AM -0800, David Miller wrote:
> > > > > That's why I'm not worried about this issue and it's not critical at
> > > > > all.
> > > > 
> > > > If a module calls sunserial_console_match() that's an Oops.
> > > 
> > > That's true.
> > > 
> > > I'm trying to figure out a way to fix this.
> > 
> > #ifdef FOO_CONSOLE around the sunserial_console_match() calls in the  
> > drivers should work.
> 
> It absolutely doesn't work, I tried this, see my other reply.
> 
> The issue is add_preferred_console() is __init, driver probe calls are
> __devinit which are either __init or not __init.
> 
> So even with the FOO_CONSOLE ifdef (or something similar like the
> patch I posted) we'll still get section mismatch warnings.
>...

Sorry, I shouldn't suggest stuff I haven't tried myself... :-(

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

