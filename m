Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZFWF7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZFWF7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZFWF7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:59:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45282 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZFWF7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:59:32 -0400
Subject: Re: [PATCH] mm/init: cpu_hotplug_init() must be initialized before
 SLAB
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sachin Sant <sachinp@in.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
References: <1245717089.4017.18.camel@pasglop>
	 <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
Date: Tue, 23 Jun 2009 08:59:33 +0300
Message-Id: <1245736773.2880.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
> > +	/*
> > +	 * This initializes the mutex used by get/put_online_cpus()
> > +	 * which is used by SLAB
> > +	 */
> > +	cpu_hotplug_init();

On Mon, 2009-06-22 at 19:29 -0700, Linus Torvalds wrote:
> Oh fudge it.
> 
> Why not get rid of that stupid thing, rather than have that subtle 
> dependency and a comment for it.
> 
> IOW, does this simpler alternative also work?
> 
> When given the choice of simplifying and removing code, always do so. 
> 
> Static initializers are much nicer than having to worry about when 
> something gets initialized, no?

Looks good to me. Thanks for fixing it up, Linus!

			Pekka

