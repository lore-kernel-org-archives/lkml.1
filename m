Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYCUP4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYCUP4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYCUP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:56:00 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56655 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYCUPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:55:59 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: iommu: it could use some documentation
References: <20080319145811.GA27113@elf.ucw.cz>
	<20080319151346.GA28798@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Mar 2008 16:55:51 +0100
In-Reply-To: <20080319151346.GA28798@elte.hu>
Message-ID: <87bq58hy0o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Mar 2008 15:49:15.0610 (UTC) FILETIME=[1DB323A0:01C88B6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> > +	iommu=		[x86]
> > +		off
> > +		force
> > +		noforce
> > +		biomerge
> > +		panic
> > +		nopanic
> > +		merge
> > +		nomerge
> > +		forcesac
> > +		soft
> 
> these are mostly quirks to get boards booting

Actually no. Except perhaps for iommu=soft none of them is related
to any  hardware issues. They all tune various performance trade offs
and were supplied for performance tuning originally.

-Andi
