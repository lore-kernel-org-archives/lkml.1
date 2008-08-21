Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYHUNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYHUNDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYHUNDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:03:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbYHUNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:03:15 -0400
Date: Thu, 21 Aug 2008 15:02:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Message-ID: <20080821130259.GA22887@elte.hu>
References: <48AD7F80.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD7F80.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Converting __cpuinit functions called out of init_amd() (and similar 
> others) to __init (and making them subject of xxx_initcall() handling 
> isn't valid, as they would no longer be called for hot plugged CPUs.
> 
> Further, since it's likely that in virtualized environments the MSR 
> write would at best be ignored, I'd also recommend using the 
> fault-safe accessors here *and* check that the bit actually got set 
> before setting PCI_HAS_IO_ECS (one would obviously have to BUG() when 
> hot-plugged CPUs fail to set the bit when those available at boot 
> successfully did so).

hm, which patch is this exactly, and in what tree? It's not upstream nor 
in -tip.

	Ingo
