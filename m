Return-Path: <linux-kernel-owner+w=401wt.eu-S934131AbYBMX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbYBMX7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761155AbYBMX7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:59:01 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57787 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760434AbYBMX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:59:00 -0500
Date: Thu, 14 Feb 2008 01:58:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: harvey.harrison@gmail.com, torvalds@linux-foundation.org,
       davem@davemloft.net, tglx@linutronix.de, hpa@zytor.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
	symbols going away
Message-ID: <20080213235843.GG12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick> <20080213223455.GB12383@cs181133002.pp.htv.fi> <20080213224308.GD12383@cs181133002.pp.htv.fi> <20080213145405.35fb5733.akpm@linux-foundation.org> <20080213232248.GF12383@cs181133002.pp.htv.fi> <20080213154331.f11efc63.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080213154331.f11efc63.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:43:31PM -0800, Andrew Morton wrote:
> On Thu, 14 Feb 2008 01:22:48 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > I don't get your point why bigger API changes should still be allowed 
> > without any advance warning while removing an export should require 
> > deprecation periods.
> 
> Because the cost to us of giving people a few months warning is miniscule,
> and doing so a) is courteous to our users and b) possibly avoids driving
> away testers.

The miniscule cost is my spare time and my nerves.

These unexport discussions are _the_ thing that have turned kernel 
development from having been fun into creating anger for me. If your 
goal is to bring me to quitting kernel development and spending my spare 
time differently you've already gotten quite near to reaching your goal.

> otoh the cost to us of avoiding large API changes is much much higher, so
> the tradeoff has a different outcome.
> 
> > If you want to offer a stable API for external modules then please do 
> > it completely and with all consequences.
> 
> Sorry, but you have this belief that if we do X in one case then we should
> rigorously do X in all cases.  That everything we do sets precedents which
> must be forever and in all cases followed.  That it is all about rules and
> sticking to them.  That if you can catch person A taking action B then you
> can trap that person into doing B in all cases for ever more.
> 
> Well it doesn't work like that.  Each case is different and each case has
> pros and cons and each one needs to be weighed according to those pros and
> cons.

Unexports are done immediately when there's a subsystem maintainer 
taking a patch and deprecation periods are required when a patch has to 
go through you...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

