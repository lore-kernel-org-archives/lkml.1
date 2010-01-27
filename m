Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045Ab0A0OkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0A0OkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146Ab0A0OkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:40:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49511 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0A0OkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:40:04 -0500
Date: Wed, 27 Jan 2010 15:39:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <petkovbb@googlemail.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
	mce_cpu_specific_poll
Message-ID: <20100127143957.GE12522@basil.fritz.box>
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <4B6032E7.1090900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6032E7.1090900@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The i7core_edac driver covers the Nehalem chipsets. It is at:

Erm no, first Nehalem isn't a chipset and then it only covers
parts of the space (some subset of Nehalems with a specific uncore). 

This does not include Xeon 75xx where all this is quite different.

> I agree. The EDAC module handles memory errors for several memory controllers,
> including some on non-x86 architectures. Letting this decode to happen outside
> the kernel, just for a very few set of memory controllers, seems a bad idea.

Again you can't do all the things mcelog does in kernel space only.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
