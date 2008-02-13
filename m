Return-Path: <linux-kernel-owner+w=401wt.eu-S932595AbYBMP5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbYBMP5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764105AbYBMP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:57:11 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:51193 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761213AbYBMP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:57:10 -0500
Date: Wed, 13 Feb 2008 18:57:13 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
Message-ID: <20080213155713.GA376@jurassic.park.msu.ru>
References: <20080213052903.B1F1CDBA2@gherkin.frus.com> <20080213092208.GC21614@elte.hu> <20080213130432.GE6344@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213130432.GE6344@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:04:32PM +0100, Ingo Molnar wrote:
> > > Unless someone has a good idea what's causing this, I see a massive 
> > > "git bisect" project in my future.  Won't be able to spend any time 
> > > with this until at least the weekend :-(.
> > 
> > hm, is this SMP? Alpha uses asm-generic/percpu.h. One "early bootup" 
> > effect on Alpha that i can think of could have been this family of 
> > commits:
> 
> another possibility would be to turn off PRINTK_TIMESTAMPS [if they are 
> on in your .config].

No SMP, no PRINTK_TIMESTAMPS in my case. Looks like it dies trying to
to switch to vga console, but I had no time to debug this yet...

Ivan.
