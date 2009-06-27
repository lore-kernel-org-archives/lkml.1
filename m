Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZF0Vet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZF0Vet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 17:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZF0Vej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 17:34:39 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37522 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF0Vej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:34:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19014.36968.722952.729071@pilspetsen.it.uu.se>
Date: Sat, 27 Jun 2009 23:34:32 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
In-Reply-To: <4A46728B.80301@zytor.com>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<19013.29264.623540.275538@pilspetsen.it.uu.se>
	<20090627042556.GA31085@lackof.org>
	<19013.59767.139956.971375@pilspetsen.it.uu.se>
	<4A46728B.80301@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Mikael Pettersson wrote:
 > > 
 > > Sure. This is from 2.6.31-rc1 with the commit commented out and
 > > replaced by a debug printk:
 > > 
 > > identify_cpu: ->x86_phys_bits == 36, would change iomem_resource.end from 0xffffffffffffffff to 0x0000000fffffffff
 > > 
 > > which looks correct for HIGHMEM64G.
 > 
 > OK, I'm going to revert the checkin... however, we still need to figure
 > out what the right answer here is, and why this broke (and why none of
 > my tests showed this failure...)
 > 
 > However, it is clear that the answer is more complex than we originally
 > anticipated.  Mikael, would you be willing to run some experiments over
 > the near future?

Yes

/Mikael
