Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbYAaQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbYAaQMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765904AbYAaQL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:11:59 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50103 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765774AbYAaQL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:11:58 -0500
Date: Thu, 31 Jan 2008 18:12:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131161235.GB19700@cs181133002.pp.htv.fi>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131160033.GA11501@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:00:33PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > You tested x86 but broke more than half a dozen other archtectures, 
> > with at least 3 different commits breaking other architectures.
> 
> Note that all known breakages are fixed in current -git, except for the 
> s390 problem that Martin/Nick posted the fix.

What about the breakages caused by commit 
a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 (this commit broke the 
defconfig compilation on at least avr32, blackfin, sh, sparc and uml)?

This commit touched two different not x86 specific headers, and both of 
them broke (different) architectures.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

