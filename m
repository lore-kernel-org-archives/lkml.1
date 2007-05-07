Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbXEGRHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbXEGRHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934438AbXEGRHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:07:50 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2739 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934415AbXEGRHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:07:49 -0400
Date: Mon, 7 May 2007 19:07:43 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
In-Reply-To: <m3lkg0a88y.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0705071901020.1479@scrub.home>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3y7k1biov.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705070343330.2733@scrub.home> <m3tzupc6wz.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705071318150.1479@scrub.home> <m3r6psc0ee.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705071509290.1479@scrub.home> <463F27CE.2040008@garzik.org>
 <Pine.LNX.4.64.0705071538060.1479@scrub.home> <m3lkg0a88y.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2007, Krzysztof Halasa wrote:

> Roman Zippel <zippel@linux-m68k.org> writes:
> 
> > HDLC doesn't really look like simple library code, what's up with all the 
> > HDLC_* options?
> 
> Sub-modules.

So it's not simple library code, or is it?

> Anyway, what does the patch "screw" exactly?

Normal dependencies, you basically have to manually make sure they are 
correct (and it seems with your patch they aren't). Again, _please_ (with 
sugar on top) don't use select unless you have a good reason for it.

bye, Roman
