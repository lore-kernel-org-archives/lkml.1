Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYAaGLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYAaGLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYAaGLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:11:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYAaGLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:11:30 -0500
Date: Wed, 30 Jan 2008 22:11:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] Remove deprecation of a.out ELF interpreters
Message-Id: <20080130221138.97cc32f1.akpm@linux-foundation.org>
In-Reply-To: <20080131030919.GA27115@one.firstfloor.org>
References: <20080130084041.GA8429@basil.nowhere.org>
	<20080130152915.6e7d5865.akpm@linux-foundation.org>
	<20080131030919.GA27115@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 04:09:19 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Jan 30, 2008 at 03:29:15PM -0800, Andrew Morton wrote:
> > On Wed, 30 Jan 2008 09:40:41 +0100
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > 
> > > Andrew has already queued the patch to remove the support for a.out
> > > ELF interpreters. So remove the deprecation with it too.
> > > 
> > 
> > I'm trying to find which patch I might have queued which did this and came
> > up blank. 
> 
> Sorry I somehow thought you had it queued.
> 
> My patch makes parts of David's patch obsolete because he makes 
> the code ifdef, but I remove the code completely. David also
> does some other cleanups which still make sense. 
> 
> So I think the correct way is to apply my patch first and then David's
> and just ignore all the rejects and refresh.  The result should be correct.
> 
> Basically after that only the core dump changes in David's patch should
> be left over.
> 
> Can you do that or should I resubmit both patches in a merged form?
> (I can do that too) 
> 

Your patch on top of rc8-mm1 would be simplest for me.

I'm at a bit of a loss because I don't appear to have a copy of the patch
which we're discussing handy.

