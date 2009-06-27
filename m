Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZF0Taj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZF0Taj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZF0Taa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 15:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58445 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZF0Ta3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 15:30:29 -0400
Message-ID: <4A46728B.80301@zytor.com>
Date: Sat, 27 Jun 2009 12:27:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<20090627042556.GA31085@lackof.org> <19013.59767.139956.971375@pilspetsen.it.uu.se>
In-Reply-To: <19013.59767.139956.971375@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> Sure. This is from 2.6.31-rc1 with the commit commented out and
> replaced by a debug printk:
> 
> identify_cpu: ->x86_phys_bits == 36, would change iomem_resource.end from 0xffffffffffffffff to 0x0000000fffffffff
> 
> which looks correct for HIGHMEM64G.

OK, I'm going to revert the checkin... however, we still need to figure
out what the right answer here is, and why this broke (and why none of
my tests showed this failure...)

However, it is clear that the answer is more complex than we originally
anticipated.  Mikael, would you be willing to run some experiments over
the near future?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

