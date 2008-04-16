Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYDPWbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYDPWbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764675AbYDPW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:28:13 -0400
Received: from elvis.franken.de ([193.175.24.41]:34441 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594AbYDPW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:28:08 -0400
Date: Thu, 17 Apr 2008 00:27:56 +0200
To: Roel Kluin <12o3l@tiscali.nl>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6 v2] MIPS: ip27-timer: unsigned irq to evaluate allocate_irqno()
Message-ID: <20080416222755.GA18832@alpha.franken.de>
References: <480559DC.2060807@tiscali.nl> <20080416091554.GA6026@alpha.franken.de> <480616C6.3080203@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480616C6.3080203@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 05:09:58PM +0200, Roel Kluin wrote:
> Thomas Bogendoerfer wrote:
> > On Wed, Apr 16, 2008 at 03:43:56AM +0200, Roel Kluin wrote:
> >> irq is unsigned, cast to signed to evaluate the allocate_irqno() return value,
>  
> >> +		if ((int) irq < 0)
> > 
> > Why don't you just make irq and rt_timer_irq an int ?
> 
> Ok, thanks, It should be right, but I cannot test this (no hardware).

I've tested it on real hardware.

Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
