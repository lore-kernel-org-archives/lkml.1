Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYCYQQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYCYQQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYCYQQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:16:42 -0400
Received: from www.tglx.de ([62.245.132.106]:57849 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbYCYQQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:16:41 -0400
Date: Tue, 25 Mar 2008 17:16:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CPA: Add statistics about state of direct mapping v3
In-Reply-To: <20080325161430.GR2170@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803251714100.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025333.BAF5F1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211822220.3781@apollo.tec.linutronix.de> <20080321175538.GI2346@one.firstfloor.org> <20080322095041.GA20734@basil.nowhere.org>
 <alpine.LFD.1.00.0803251631050.3781@apollo.tec.linutronix.de> <20080325161430.GR2170@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Mar 2008, Andi Kleen wrote:

> On Tue, Mar 25, 2008 at 04:40:43PM +0100, Thomas Gleixner wrote:
> > On Sat, 22 Mar 2008, Andi Kleen wrote:
> > 
> > > [I didn't switch to debugfs because I strongly disagreed with that
> > > suggestion. But all the other points you made are addressed.]
> > 
> > Halfways :)
> 
> Ok.
> 
> > > +	update_page_count(PG_LEVEL_1G, pages);
> > > +
> > 
> >   update via function call with pages = 0 ?
> 
> Didn't get that one. Can you clarify?

You have the direct increment and the function call in
phys_pud_init. The function is always called with pages=0 because
nothing ever increments pages.

Thanks,
	tglx
