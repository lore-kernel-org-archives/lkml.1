Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYBYXfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYBYXfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYBYXe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:34:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbYBYXe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:34:56 -0500
Date: Mon, 25 Feb 2008 18:34:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080225233449.GA25448@infradead.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi> <20080225144922.ae716e7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225144922.ae716e7d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 02:49:22PM -0800, Andrew Morton wrote:
> the things which it finds.
> 
> > +static DECLARE_MUTEX(kmmio_init_mutex);
> 
> That's not a mutex.
> 
> > +	down(&kmmio_init_mutex);
> 
> It's a semaphore.  Please do convert it to a mutex.
> 
> Andy, I'd say that addition of new semaphores is worth a warning - they're
> rarely legitimate.

I'm not sure that any semaphore should be a warning, but the initializer
for semaphore used as binary mutex (DECLARE_MUTEX and init_MUTEX) are
worth it.

