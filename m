Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYGHOHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYGHOHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYGHOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:07:41 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51861 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368AbYGHOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:07:40 -0400
Date: Tue, 8 Jul 2008 15:07:15 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 0/3] Genclk: generic framework for clocks managing
	[v3.1]
Message-ID: <20080708140715.GE24620@fluff.org.uk>
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708134242.GA6176@doriath.ww600.siemens.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 05:42:42PM +0400, Dmitry Baryshkov wrote:
> Hi,
> 
> This is again a set of patches to unify the management of clocks and
> allow easy registration and unregistration of them. This is neccessary
> to cleanly support such devices as toshiba mobile companion chips,
> sa1111 companion, ASIC3 companion, etc. Also it brings code unification,
> especially for a lot of arm sub-arches which share nearly the same code.

Any particular reason why you've not changed the enable and disable
methods to one single method taking a bool?
 
> Changes from the previous patchset:
> * Change the name as requested by Ben: clocklib -> generic clk (genclk)
> * Move from lib/clocklib.c to kernel/genclk/*
> * Fix locking in generic code
> 
> * Rebase PXA patch to the current Russell's tree.
> * Interlock access to CKEN registers on PXA.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
