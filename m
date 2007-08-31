Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXHaB6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXHaB6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 21:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXHaB60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 21:58:26 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3815 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbXHaB60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 21:58:26 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull request] scheduler updates
Date: Fri, 31 Aug 2007 03:58:03 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070824141215.GA24403@elte.hu> <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708310358.04411.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 24 August 2007, Linus Torvalds wrote:

> Why the hell can't you just make the code sane and do what the comment
> *says* it does, and just admit that HZ has nothing what-so-ever to do with
> that thing, and then you do
>
> 	unsigned int sysctl_sched_granularity __read_mostly = 3000000ULL;
>
> and be done with it. Instead of this *insane* expectation that HZ is
> always 1000, and any other value means that you want bigger granularity,
> which is not true and makes no sense.

I'd actually like to base this on the cpu frequency or the number of cycles to 
be precise, e.g. with 10^7 cycles this would be 100ms for 100MHz and 10ms for 
1GHz.

bye, Roman
