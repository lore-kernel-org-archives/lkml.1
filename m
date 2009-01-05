Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZAESvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZAESvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAESvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:51:14 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50211 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbZAESvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:51:14 -0500
Date: Mon, 5 Jan 2009 12:51:11 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long periods
Message-ID: <20090105185111.GA18084@sgi.com>
References: <20090105175641.GA17055@sgi.com> <49625519.4050902@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49625519.4050902@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Jan 05, 2009 at 01:44:41PM -0500, Gregory Haskins wrote:
> Dimitri Sivanich wrote:
> >
> > I'm wondering if anyone else has run into this problem, and whether they've
> > found a resolution for it?
> >
> >   
> 
> Hi Dimitri,
>   I have observed similar problems on my opensuse 11.0 box (2.6.25
> based) when doing kernel builds.  Often times other apps will get
> starved (like firefox, etc).  I was talking to peterz about it and he
> pointed me at a commit that went into 28-rcx that fixes this (the sha
> escapes me at the moment).  I've been meaning to pull the patch into our
> 2.6.25 and 2.6.27 trees to verify if it fixes it, but I have fairly high
> confidence it will.  Perhaps Peter can point you at the same patch and
> you can give it a whirl.  For the time being, can you see if 28 is fixed?
> 

2.6.28 appears to be a little bit worse, actually:
Counts:
0: 50165855
1: 8879
2: 5462
3: 4990
4: 91805284

^C
# uname -r
2.6.28-03114-g3c92ec8

The master thread hangs up after printing only one set of counts.
