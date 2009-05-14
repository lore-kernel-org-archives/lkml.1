Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZENUIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZENUIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZENUIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:08:40 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57175 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZENUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:08:39 -0400
Date: Fri, 15 May 2009 01:38:29 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090514200829.GE30963@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090513161201.GA13911@in.ibm.com> <Pine.LNX.4.44L0.0905141555310.4344-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905141555310.4344-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 04:02:16PM -0400, Alan Stern wrote:
> On Wed, 13 May 2009, K.Prasad wrote:
> 
> > Hi Alan,
> > 	Please find a new set of patches with the following changes.
> > I am eager to know if you think that they are ready for submission towards
> > upstream acceptance.
> 
> This is looking pretty good.  Only one thing caught my eye: 
> switch_to_thread_hw_breakpoint and switch_to_none_hw_breakpoint do 
> nothing but call the corresponding arch-specific routines.  You might 
> as well eliminate them and have the callers invoke the arch-specific 
> routines instead.
> 
> Alan Stern
>

Sure. I will eliminate the above two functions and also remove the msleep()
call in ftrace startup selftest code path.

With these two changes I plan to submit the code for -tip acceptance
directly.

I wish to thank you profusely for the in-depth code reviews,
suggestions, unearthing corner-case issues and the immense time and effort
taken for the same. The patch wouldn't have been as better but for your
involvement!

Thanks,
K.Prasad

