Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbYC0T1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbYC0T1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbYC0T0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:26:51 -0400
Received: from www.tglx.de ([62.245.132.106]:42604 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbYC0T0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:26:51 -0400
Date: Thu, 27 Mar 2008 20:26:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Markus Rehbach <markus.rehbach@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <47EBE7AE.5020402@gmx.de>
Message-ID: <alpine.LFD.1.00.0803272025470.3781@apollo.tec.linutronix.de>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de> <47EBE7AE.5020402@gmx.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Markus Rehbach wrote:
> Thomas Gleixner schrieb:
> > On Tue, 25 Mar 2008, Andrew Morton wrote:
> 
> >> http://lkml.org/lkml/2008/3/21/202 and it's already in the regresison list.
> >
> > Same here. And both are AMD X2 early stepping machines.
> 
> > A dropped workaround for the prefetch bug in early X2s and
> > Opterons. Patch below.
> 
> The patch cures it. Tested with rc5-git5, and it was 100%
> reproducible here.

Thanks for testing. Fix is queued for Linus.

Thanks,

	tglx
