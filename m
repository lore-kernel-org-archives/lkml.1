Return-Path: <linux-kernel-owner+w=401wt.eu-S1763306AbYBZRKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763306AbYBZRKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbYBZRK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:10:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbYBZRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:10:27 -0500
Date: Tue, 26 Feb 2008 12:10:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080226171015.GB6634@infradead.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi> <20080225144922.ae716e7d.akpm@linux-foundation.org> <20080225233449.GA25448@infradead.org> <20080225214200.yge03wi7ksoccw0k@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225214200.yge03wi7ksoccw0k@webmail.spamcop.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 09:42:00PM -0500, Pavel Roskin wrote:
> It looks like a mutex, it acts like a mutex, but it isn't a mutex, it's a 
> trap for the unwary.  Weird.  I was annoyed by it before; now I see a 
> fellow developer actually getting into that trap.
>
> I'd say, rename DECLARE_MUTEX to DECLARE_SEMAPHORE and let external code be 
> fixed one way or another (i.e. stick with the "mutex" name or stick with 
> the semaphore functionality if it's really needed).

It's a semaphore used as mutex.  Until we got struct mutex this was
perfectly fine and now we're phasing it out and will hopefully get rid
of it soon.  It just takes some time to convert all users.

