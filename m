Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXCCWIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXCCWIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932895AbXCCWH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:07:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760AbXCCWH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:07:59 -0500
Date: Sat, 3 Mar 2007 14:07:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303140744.b22699dd.akpm@linux-foundation.org>
In-Reply-To: <45E9E910.2070804@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 16:30:56 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Sat, 03 Mar 2007 15:40:42 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
> >> I am sick and tired of the "this is hard, let userspace do it" attitude.
> > 
> > Anything you try to do in-kernel will catastrophically screw up some
> > workloads.  You don't have a chance of getting this right.
> 
> Any time you follow the directions of one userspace program,
> you can screw up others.  I suspect that userspace has far
> less of a chance of getting it right than the kernel.
> 
> ALSA would be a good example of why it is bad to export
> tuning knobs directly to userspace - many sound cards have
> non-standard names for the volume controls, making it almost
> impossible for userspace to present the user with a simple
> user interface for tweaking the volume.

What on earth are you talking about?  Please, go and look at the thing.

> > You are the kernel.  The user just read an entire kernel tree.  You face a
> > binary decision: do you cache that tree or do you not?  Your time starts
> > now.  What is your answer?
> 
> Lets turn this around.
> 
> The user has been accessing the kernel tree over and over
> again, for hours on end (compile testing a patch).  Along
> comes a backup program, that tells you to evict the whole
> thing from the cache.
> 
> What do you do?

Well, backup programs are a unique case.  Let's say instead that the user
has just generated a 600MB ISO image.

The kernel *just doesn't know* whether the user will next try to read the
kernel tree or will next try to read that ISO image.

That, Rik, is my point, and is the entire point of this work.

> How can you make global policy decisions based on the intent
> of one program?

You can't, that's why I did this work.

> Only the kernel knows the state of the whole system and has
> observed the behaviour of all the processes.

The kernel knows the past, and tries to predict the future from that past. 
Sometimes, as you well know, that goes badly wrong.  That's why I did this
work.

> One process has
> no idea what the other processes in the system are doing.

argh.  Please, next time click on the link?

	http://userweb.kernel.org/~akpm/pagecache-management/

