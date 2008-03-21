Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYCUSPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYCUSPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYCUSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:14:59 -0400
Received: from www.tglx.de ([62.245.132.106]:58902 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbYCUSO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:14:58 -0400
Date: Fri, 21 Mar 2008 19:14:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Readd rdmsrl_safe
In-Reply-To: <20080321180612.GK2346@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211909501.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de> <20080321171636.GE2346@one.firstfloor.org> <alpine.LFD.1.00.0803211857030.3781@apollo.tec.linutronix.de>
 <20080321180612.GK2346@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:
> > > Well all of paravirt.h uses macros. I did the same for consistency.
> > 
> > consistency ?
> 
> At least I consider it clean and consistent to use similar
> style as the other code in that file for new code I add.

inlines are generally preferred and the existing macro pile is no
excuse to add more.

> > > If you want inlines it would be better to just convert it all in one
> > > go (but please only after this patch was applied)
> > 
> > Of course. We don't want to burden work on your shoulders.
> 
> Well you signed up for the work yourself last year ;-) It was your choice.

Yeah, I signed up for maintaining. And review is one of the tasks of a
maintainer. So when I do a review and ask for a macro -> inline change
I don't see that this means that I have to do the change myself.

Thanks,

	tglx
