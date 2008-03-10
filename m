Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYCJRDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYCJRDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYCJRDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:03:47 -0400
Received: from 74-92-59-67-NewEngland.hfc.comcastbusiness.net ([74.92.59.67]:41225
	"EHLO shelob.surriel.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbYCJRDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:03:46 -0400
Date: Mon, 10 Mar 2008 13:03:41 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH -mm] extend sysrq-p functionality to cover all CPUs
Message-ID: <20080310130341.74eac553@bree.surriel.com>
In-Reply-To: <20080310092413.6102c965.akpm@linux-foundation.org>
References: <20080309221458.20642e48@bree.surriel.com>
	<20080309224759.6fead9af.akpm@linux-foundation.org>
	<20080310093024.55a4ff90@bree.surriel.com>
	<20080310092413.6102c965.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 09:24:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > however just
> > sysrq-p seems like a waste to have because it will probably not
> > print anything useful on a large CPU system...
> 
> Yeah, sometimes it helps to keep hitting it until you get the right CPU,
> but that rather depends on interrupt distribution.
> 
> It would be neat to suppress the trace for idle CPUs.  I don't _think_
> there's a need to display the trace for idle CPUs in sysrq-P?
> 
> > If you still want it to be a separate letter, just let me know
> > which one of the last four I should take.
> 
> l :)

OK, I'll do that.  I will also change the show_lock to spinlock_irq_save
just in case sysrq-p gets invoked from multiple cpus simultaneously.

I'll send you the updated patch in a separate email, so the changelog
and commit logs do not have this discussion.

