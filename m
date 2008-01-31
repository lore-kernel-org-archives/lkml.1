Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYAaCgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYAaCgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYAaCf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:35:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYAaCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:34:59 -0500
Date: Thu, 31 Jan 2008 04:09:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] Remove deprecation of a.out ELF interpreters
Message-ID: <20080131030919.GA27115@one.firstfloor.org>
References: <20080130084041.GA8429@basil.nowhere.org> <20080130152915.6e7d5865.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130152915.6e7d5865.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 03:29:15PM -0800, Andrew Morton wrote:
> On Wed, 30 Jan 2008 09:40:41 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > 
> > Andrew has already queued the patch to remove the support for a.out
> > ELF interpreters. So remove the deprecation with it too.
> > 
> 
> I'm trying to find which patch I might have queued which did this and came
> up blank. 

Sorry I somehow thought you had it queued.

My patch makes parts of David's patch obsolete because he makes 
the code ifdef, but I remove the code completely. David also
does some other cleanups which still make sense. 

So I think the correct way is to apply my patch first and then David's
and just ignore all the rejects and refresh.  The result should be correct.

Basically after that only the core dump changes in David's patch should
be left over.

Can you do that or should I resubmit both patches in a merged form?
(I can do that too) 

-Andi
