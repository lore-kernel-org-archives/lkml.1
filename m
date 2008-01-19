Return-Path: <linux-kernel-owner+w=401wt.eu-S1761173AbYASA2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761173AbYASA2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 19:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYASA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 19:28:32 -0500
Received: from waste.org ([66.93.16.53]:34316 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbYASA2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 19:28:31 -0500
Subject: Re: PROBLEM: Celeron Core
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chodorenko Michail <misha@one.by>, linux-kernel@vger.kernel.org
In-Reply-To: <p73prvyalfl.fsf@bingen.suse.de>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by>
	 <p73prvyalfl.fsf@bingen.suse.de>
Content-Type: text/plain; charset=utf-8
Date: Fri, 18 Jan 2008 18:27:57 -0600
Message-Id: <1200702477.25782.41.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 22:11 +0100, Andi Kleen wrote:
> Chodorenko Michail <misha@one.by> writes:
> 
> > I have a laptop "Extensa 5220", with the processor Celeron based on 'core'
> > technology.
> > There is ~ / arch/i386/kernel/cpu/cpufreq/p4-clockmod.c in the kernel
> > source code
> > but there's no line identification of my CPU for apply freqency change
> > need to add a ID line 0х16
> 
> Note that driver will likely do clock throttling on your CPU.
> Using that is usually a bad idea because it does not actually
> safe power. It's only intended to let the CPU cool down in some situations.

Power consumption is more or less exactly equal to heat production
(that's where the power goes, after all!), so either clock throttling
DOES save power or it DOES NOT cool the CPU.

-- 
Mathematics is the supreme nostalgia of our time.

