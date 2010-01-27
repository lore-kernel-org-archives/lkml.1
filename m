Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769Ab0A0PGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0A0PGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772Ab0A0PGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:06:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0A0PGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:06:12 -0500
Message-ID: <4B605617.6050006@redhat.com>
Date: Wed, 27 Jan 2010 13:04:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <petkovbb@googlemail.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to	mce_cpu_specific_poll
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <4B6032E7.1090900@redhat.com> <20100127143957.GE12522@basil.fritz.box>
In-Reply-To: <20100127143957.GE12522@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> it only covers
> parts of the space (some subset of Nehalems with a specific uncore). 

The changes for Xeon 55xx are minimal. I did some tests with the driver on it already.

> This does not include Xeon 75xx where all this is quite different.

I haven't the datasheets for 75xx, so I can't say for sure if it would be better to
use the same driver or to fork it.

>> I agree. The EDAC module handles memory errors for several memory controllers,
>> including some on non-x86 architectures. Letting this decode to happen outside
>> the kernel, just for a very few set of memory controllers, seems a bad idea.
> 
> Again you can't do all the things mcelog does in kernel space only.

Well, the error parsing can be done in kernel space in a standard way provided
by the edac interface.

I don't see why not the mcelog userspace shouldn't use the EDAC interface as one
of its source, getting memory errors from it, avoiding the need of re-parsing
the errors.

Cheers,
Mauro.

