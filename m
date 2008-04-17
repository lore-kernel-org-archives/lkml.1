Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbYDQJcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbYDQJcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932909AbYDQJTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:19:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932905AbYDQJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:19:33 -0400
Date: Thu, 17 Apr 2008 02:18:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417021813.04df7912.akpm@linux-foundation.org>
In-Reply-To: <20080417090626.GA14383@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 11:06:26 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > By keeping all this code out of -mm you haven't solved any of the 
> > merge/integration problems which we had in 2.6.24-rcX.  They're all 
> > still there.  All you did was to push them out of the two-month 
> > integrate-and-test period and put them into the 2.6.25 merge window 
> > instead.
> 
> ... hm, i think there's really no problem here at all: most of the merge 
> problems you cited were due to clearly out-of-tree patches that sit in 
> x86.git/testing for the convenience of our testers and contributors, 
> that we have no intention to push upstream.

Are those out-of-tree patches also in linux-next?  The page-flags and prctl
changes are there.  And those are planned for 2.6.26, aren't they?


