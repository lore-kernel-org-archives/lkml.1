Return-Path: <linux-kernel-owner+w=401wt.eu-S934683AbXGRS3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbXGRS3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbXGRS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:29:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45931 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbXGRS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:29:28 -0400
Date: Wed, 18 Jul 2007 20:29:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <andi@firstfloor.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
In-Reply-To: <20070718182021.GA3898@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de>
 <469E3806.4030804@zytor.com> <20070718182021.GA3898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18 2007 20:20, Andi Kleen wrote:
>> 
>> Well, how big the vmlinux file is matters if it doesn't fit in memory
>> with enough time to get to the phase where it is dumping the init
>> sections.  
>
>If you don't have enough memory for a few tens of KB of init sections
>you're very unlikely to have enough memory for user space.

If the code was not too hackish, I would not buy that.
Routers for example can run -- minus the userspace utilities required to set
things up -- "without" userspace. Maybe someone even comes along and
writes the network interface setup as __init kernel code. If not that,
maybe a code generator. I also remember someone who posted sort of a
"kernel console" patch (same reason - to avoid userspace).


	Jan
-- 
