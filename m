Return-Path: <linux-kernel-owner+w=401wt.eu-S938427AbYCSVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938427AbYCSVp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765443AbYCSUPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:15:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39807 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765440AbYCSUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:15:14 -0400
Date: Wed, 19 Mar 2008 09:32:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080319083228.GM11966@one.firstfloor.org>
References: <20080318209.039112899@firstfloor.org> <20080318003620.d84efb95.akpm@linux-foundation.org> <20080318141828.GD11966@one.firstfloor.org> <20080318095715.27120788.akpm@linux-foundation.org> <20080318172045.GI11966@one.firstfloor.org> <20080318104437.966c10ec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318104437.966c10ec.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 10:44:37AM -0700, Andrew Morton wrote:
> On Tue, 18 Mar 2008 18:20:45 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > What's the permission problem?  executable-but-not-readable files?  Could
> > 
> > Not writable. 
> 
> Oh.
> 
> I doubt if a userspace implementation would even try to alter the ELF
> files, really - there seems to be no point in it.   This is just complexity

Well the information has to be somewhere and i think the ELF file
is the best location for it. It makes it the most user transparent.

> > Yes it could, but i dont even want to thi nk about all the issues of
> > doing such an interface. It is basically an microkernelish approach.
> > I prefer monolithic simplicity.
> 
> It's not complex at all.  Pass a null-terminated pathname to the server and
> keep running.  The server will asynchronously read your pages for you.

But how do you update the bitmap in your scheme? 

> > And I am really not a friend of unnecessary complexity. In the end
> > complexity hurts you, no matter if it is in ring 3 or ring 0.
> 
> There is no complexity here.

I have my doubts on that if you consider update too.

-Andi
> 
