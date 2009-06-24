Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbZFXSrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbZFXSrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZFXSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:47:09 -0400
Received: from www.tglx.de ([62.245.132.106]:36783 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZFXSrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:47:08 -0400
Date: Wed, 24 Jun 2009 20:45:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Gary Hade <garyhade@us.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
In-Reply-To: <20090624112849.55b38fff@jbarnes-g45>
Message-ID: <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net> <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain> <1245859068.3216.5.camel@localhost.localdomain> <20090624161306.GC7239@us.ibm.com>
 <1245861219.3216.15.camel@localhost.localdomain> <20090624094411.08fc66e6@jbarnes-g45> <20090624175513.GE7239@us.ibm.com> <20090624112849.55b38fff@jbarnes-g45>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Jesse Barnes wrote:
> > I was thinking 32 but 64 would be better if there aren't any
> > downsides elsewhere of making the array that big.
> 
> Just chatting with Len about this; apparently the PNPACPI layer ran
> into something similar awhile back, and they had to go to a variable
> sized list of resources, due to weird machines with huge numbers of
> resources.  Matthew says he's got an idea about how to fix this up; if
> that doesn't work out I'll see about making the bus resource array into
> a list instead.

Can we just bring the limit check back and increase the number for now
until folks come up with a better solution ?

Thanks,

	tglx
