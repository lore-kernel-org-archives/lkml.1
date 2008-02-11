Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbYBKWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbYBKWmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbYBKWmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:42:43 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47895 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbYBKWmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:42:42 -0500
Date: Tue, 12 Feb 2008 00:42:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let LOG_BUF_SHIFT default to 17
Message-ID: <20080211224233.GE2959@cs181133002.pp.htv.fi>
References: <20080128221223.GE8767@does.not.exist> <20080201162003.GB15156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080201162003.GB15156@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 05:20:03PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > 16 kB is often no longer enough for a normal boot of an UP system.
> > 
> > And even less when people e.g. use suspend.
> > 
> > 17 seems to be a more reasonable default for current kernels on 
> > current hardware (it's just the default, anyone who is memory limited 
> > can still lower it).
> 
> agreed - but i think the default should be even higher. Many reported 
> dmesg's are truncated at the really interesting bits so it's a real 
> problem in practice.

17 is 128 kB.

Do we really have that many truncated dmesg's with LOG_BUF_SHIFT=17?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

