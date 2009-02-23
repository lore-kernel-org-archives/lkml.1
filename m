Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZBWQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZBWQ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZBWQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:28:50 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35596 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753073AbZBWQ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:28:50 -0500
Date: Mon, 23 Feb 2009 11:20:34 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] slub: move min_partial to struct kmem_cach
In-Reply-To: <alpine.DEB.2.00.0902230821510.23216@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0902231119390.22276@qirst.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com> <alpine.DEB.1.10.0902231108200.22276@qirst.com> <alpine.DEB.2.00.0902230821510.23216@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, David Rientjes wrote:

> > Move the ilog2 use into calculate_min_partial()? Otherweise
> > calculate_min_partial is merely enforcing limits and not doing any
> > calculations.
> >
>
> The second patch in this series as a /sys/kernel/slab/cache/min_partial
> tunable that uses calculate_min_partial() to enforce a sane range, so
> while it may not actually be doing any calculations, the ilog2() is
> appropriately placed in kmem_cache_open().  We don't want to be taking the
> log of the user's min_partial value.

Then Rename the function to set_min_partial()?


