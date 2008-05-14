Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbYENQA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbYENQA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYENQAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:00:49 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3473 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYENQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:00:48 -0400
Date: Wed, 14 May 2008 16:59:26 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch: update the 80-char-line check to allow for long strings
Message-ID: <20080514155926.GF2821@shadowen.org>
References: <20080514005325.765178fc@ephemeral> <1210751346.10126.8.camel@twins> <20080514104938.4b16c735@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514104938.4b16c735@ephemeral>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:49:38AM -0400, Andres Salomon wrote:
> On Wed, 14 May 2008 09:49:06 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2008-05-14 at 00:53 -0400, Andres Salomon wrote:
> > > 19:29 * dilinger sends his patch to lkml for a proper flaming
> > > 19:32  Quozl> dilinger: it's called "patch hardening"?  ;-}  the
> > > heat of the flames makes the patch stronger.
> > > 
> > > I've wasted too much time massaging printk strings in order to
> > > satisfy checkpatch.pl.  Comments on this?
> > 
> > How about treating like its meant to be; as a guide instead of a hard
> > rule. That means you can ignore it with good taste.. :-)
> > 
> > 
> 
> The point is that we tell people to make sure that their patches are
> checkpatch-clean.  Let's make the tool reflect what we're actually
> looking for.

We did have a mini discussion on this when Ingo suggested allowing the
strings to run off the end of the line so that grep would work.  I did
put together a patch then for this.  There was no real response to the
suggestion we should take that recommendation into CodingStyle and thus
into checkpatch.

-apw
