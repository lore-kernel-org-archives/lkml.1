Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZFWEET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZFWEET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZFWEEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:04:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34690 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZFWEEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:04:06 -0400
Subject: Re: [PATCH] mm/init: cpu_hotplug_init() must be initialized before
 SLAB
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sachin Sant <sachinp@in.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
References: <1245717089.4017.18.camel@pasglop>
	 <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 23:00:53 -0500
Message-Id: <1245729653.17035.43.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 19:29 -0700, Linus Torvalds wrote:
> 
> On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
> 
> > +	/*
> > +	 * This initializes the mutex used by get/put_online_cpus()
> > +	 * which is used by SLAB
> > +	 */
> > +	cpu_hotplug_init();
> 
> Oh fudge it.
> 
> Why not get rid of that stupid thing, rather than have that subtle 
> dependency and a comment for it.
> 
> IOW, does this simpler alternative also work?

Yes, works for me.

James


