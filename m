Return-Path: <linux-kernel-owner+w=401wt.eu-S935771AbXHIACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935771AbXHIACd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763312AbXHIACY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:02:24 -0400
Received: from ozlabs.org ([203.10.76.45]:48407 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760857AbXHIACX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:02:23 -0400
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <5d6222a80708080749t35c5c0ceo8b3b8f0cce50c666@mail.gmail.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <1186546847263-git-send-email-gcosta@redhat.com>
	 <11865468513077-git-send-email-gcosta@redhat.com>
	 <200708081200.13669.ak@suse.de>
	 <5d6222a80708080749t35c5c0ceo8b3b8f0cce50c666@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 09:18:57 +1000
Message-Id: <1186615137.17470.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 11:49 -0300, Glauber de Oliveira Costa wrote:
> On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> > > +EXPORT_SYMBOL(paravirt_ops);
> >
> > Definitely _GPL at least.
> Sure.

We ended up making it EXPORT_SYMBOL in i386 because every driver wants
to save and restore interrupt state.

But questionably-licensed drivers might be less of a concern on x86-64.

Cheers,
Rusty.


