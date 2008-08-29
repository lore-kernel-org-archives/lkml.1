Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYH2HIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYH2HIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYH2HIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:08:09 -0400
Received: from iona.labri.fr ([147.210.8.143]:58447 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbYH2HII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:08:08 -0400
Message-ID: <48B7A079.5070409@inria.fr>
Date: Fri, 29 Aug 2008 09:08:41 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] export irq_set/get_affinity() for multiqueue network drivers
References: <48B708E1.4070001@inria.fr> <20080828.135609.106382483.davem@davemloft.net>
In-Reply-To: <20080828.135609.106382483.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I think we should rather have some kind of generic thing in the
> IRQ layer that allows specifying the usage model of the device's
> interrupts, so that the IRQ layer can choose a default affinities.
> 
> I never notice any of this complete insanity on sparc64 because
> we flat spread out all of the interrupts across the machine.
> 
> What we don't want it drivers choosing IRQ affinity settings,
> they have no idea about NUMA topology, what NUMA node the
> PCI controller sits behind, what cpus are there, etc.  and
> without that kind of knowledge you cannot possible make
> affinity decisions properly.

As long as we get something better than the current behavior, I am fine
with it :)

Brice
