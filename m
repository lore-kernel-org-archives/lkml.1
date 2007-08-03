Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbXHCPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbXHCPvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbXHCPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:51:05 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:45468 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbXHCPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:51:04 -0400
Date: Fri, 3 Aug 2007 11:50:35 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Ben Collins <ben.collins@ubuntu.com>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: Regression in 2.6.22, clock problems on Turion with 32-bit kernel
In-Reply-To: <1186155828.8105.69.camel@cunning>
Message-ID: <Pine.LNX.4.64.0708031146090.3978@lancer.cnet.absolutedigital.net>
References: <1186150484.8105.57.camel@cunning>  <1186155056.2707.0.camel@laptopd505.fenrus.org>
 <1186155828.8105.69.camel@cunning>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Ben Collins wrote:

> 
> On Fri, 2007-08-03 at 08:30 -0700, Arjan van de Ven wrote:
> > > I've tried every combination of boot param revolving around clocksource
> > > and interrupts. The only thing that gets me booting is nolapic, but then
> > > again, that knocks me down to a single cpu. 
> > 
> > hummm.... I wonder how nolapic knows you down to a single cpu.......
> > that is just an entirely strange relationship.
> 
> Sorry, s/cpu/core/, but not sure if that makes a difference.

Ben, Tim,

See thread <http://marc.info/?t=118573271600006&r=1&w=2>. Short version: 
nolapic_timer should fix things for the moment. Long term: some AMD kernel 
code needs to be fixed up to deal with a broken local APIC.

Cheers,
-- 
Cal Peake

