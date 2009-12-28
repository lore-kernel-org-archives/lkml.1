Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbZL1Oyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbZL1Oyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZL1Oyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:54:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZL1Oyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:54:36 -0500
Date: Mon, 28 Dec 2009 15:54:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alain Knaff <alain@knaff.lu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       morgan@physics.ucla.edu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091228145431.GB4994@basil.fritz.box>
References: <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box> <20091225132116.6c9089f2@infradead.org> <20091225203304.GA22306@basil.fritz.box> <20091226103835.68479100@infradead.org> <20091226164029.GA10256@basil.fritz.box> <4B3752F5.3080205@knaff.lu> <20091228015446.GA3012@basil.fritz.box> <4B38882C.7060903@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B38882C.7060903@knaff.lu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 11:27:56AM +0100, Alain Knaff wrote:
> Andi Kleen wrote:
> >> disable_hlt/enable_hlt was only needed to work around a bug on TM4000
> >> (Texas Instrument) Laptops which were popular around 1994 / 1995.
> > 
> > I don't think we can fully drop support for these systems.
> > 
> > Did they have an unique PCI ID or something else that could be tested
> > for?
> 
> Floppy controllers are not PCI devices and thus have no PCI id
> unfortunately... :-(

Yes, but it's enough to identify any component in the system.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
