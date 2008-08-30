Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYH3Opn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYH3Opn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYH3Opf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:45:35 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:61080 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751218AbYH3Ope (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:45:34 -0400
Date: Sat, 30 Aug 2008 10:45:20 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make might_sleep() display the oopsing process
Message-ID: <20080830144520.GB10821@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827152139.GA11460@tsunami.ccur.com> <20080828093628.GA28783@elte.hu> <20080829162003.8f66cafe.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829162003.8f66cafe.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 07:20:03PM -0400, Andrew Morton wrote:
> On Thu, 28 Aug 2008 11:36:28 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Expand might_sleep's printk to indicate the oopsing process.
> >
> > good idea
> 
> Why?  I don't recall ever having been interested in this information.
> 
> (I shouldn't have to ask questions like this.  Please spend a little
> more time in preparing the patch descriptions).

I wrote and used the patch once, as I wanted to know
which program in a lengthy multiple-program test suite
was triggering the problem.  That made it easier coming
up with a shortened test that would replicate the problem.

However I only needed it that one time so this patch can
be considered to be exceptionally optional :)

Joe



