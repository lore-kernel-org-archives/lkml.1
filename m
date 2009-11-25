Return-Path: <linux-kernel-owner+w=401wt.eu-S935153AbZKYV7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153AbZKYV7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935134AbZKYV7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:59:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:11921 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935122AbZKYV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:59:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=EJmZNuQPvDXKb508LeVn7nmP6+tjkM6ojJG0UVBdjUTDE+K8Q4R6ist1AlkJ0hBJo
	u20kColF8YqBwgrK0wxxA==
Date: Wed, 25 Nov 2009 13:59:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <1259103315.17871.895.camel@calx>
Message-ID: <alpine.DEB.2.00.0911251356130.11347@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop>
 <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx> <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com> <1259103315.17871.895.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Matt Mackall wrote:

> I'm afraid I have only anecdotal reports from SLOB users, and embedded
> folks are notorious for lack of feedback, but I only need a few people
> to tell me they're shipping 100k units/mo to be confident that SLOB is
> in use in millions of devices.
> 

It's much more popular than I had expected; do you think it would be 
possible to merge slob's core into another allocator or will it require 
seperation forever?
