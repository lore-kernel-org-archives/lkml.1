Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbZBYHSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbZBYHSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZBYHRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:17:50 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43355 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbZBYHRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:17:49 -0500
Subject: Re: [patch 1/2] slub: move min_partial to struct kmem_cach
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0902230835120.24379@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0902231108200.22276@qirst.com>
	 <alpine.DEB.2.00.0902230821510.23216@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0902231119390.22276@qirst.com>
	 <alpine.DEB.2.00.0902230835120.24379@chino.kir.corp.google.com>
Date: Wed, 25 Feb 2009 09:17:46 +0200
Message-Id: <1235546266.6216.71.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Christoph Lameter wrote:
> > > The second patch in this series as a /sys/kernel/slab/cache/min_partial
> > > tunable that uses calculate_min_partial() to enforce a sane range, so
> > > while it may not actually be doing any calculations, the ilog2() is
> > > appropriately placed in kmem_cache_open().  We don't want to be taking the
> > > log of the user's min_partial value.
> > 
> > Then Rename the function to set_min_partial()?

On Mon, 2009-02-23 at 08:37 -0800, David Rientjes wrote:
> I don't have any strong opinions as to the specific name, so I'll leave 
> this up to Pekka.  set_min_partial(), to me, seems to indicate that 
> s->min_partial will unconditionally set to the value passed, which isn't 
> necessarily true.

Applied, thanks!

