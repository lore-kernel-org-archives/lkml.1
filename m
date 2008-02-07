Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbYBGAwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbYBGAwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934424AbYBGAsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:48:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934632AbYBGAsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:48:02 -0500
Date: Wed, 6 Feb 2008 16:47:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: softlockup: automatically detect hung TASK_UNINTERRUPTIBLE
 tasks
Message-Id: <20080206164747.60944a00.akpm@linux-foundation.org>
In-Reply-To: <20080206163111.54088622.akpm@linux-foundation.org>
References: <200801252259.m0PMxHmD012059@hera.kernel.org>
	<20080205164626.f9c920e0.akpm@linux-foundation.org>
	<1202309402.6310.0.camel@lappy>
	<20080206100513.133587fa.akpm@linux-foundation.org>
	<20080207000425.GA21918@elte.hu>
	<20080206163111.54088622.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 16:31:11 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 7 Feb 2008 01:04:25 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > Does that kernel have:
> > > > 
> > > > commit ed50d6cbc394cd0966469d3e249353c9dd1d38b9
> > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Date:   Sat Feb 2 00:23:08 2008 +0100
> > > > 
> > > >     debug: softlockup looping fix
> > > 
> > > yup.  It was fetched less than 24 hours ago.
> > 
> > does the patch below improve the situation?
> > 
> 
> Nope.
> 
> But I tested it on mainline, and mainline exhibits the never-powers-off
> symptom, whereas ed50d6cbc394cd0966469d3e249353c9dd1d38b9 demonstrates the
> powers-off-after-20-seconds symptom.  
> 
> So we _may_ be dealing with two bugs here, and your patch might have fixed
> the first, but that success is obscured by the second.  I guess I need to
> prepare a tree which has ed50d6cbc394cd0966469d3e249353c9dd1d38b9 at its
> tip.  (Wonders how to do that).  

OK, I did this (tested on a ed50d6cbc394cd0966469d3e249353c9dd1d38b9-tipped
tree) and again, the patch made no difference: the machine still pauses
20-odd seconds before (correctly) powering off.

