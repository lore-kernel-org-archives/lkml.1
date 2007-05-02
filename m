Return-Path: <linux-kernel-owner+w=401wt.eu-S1766719AbXEBQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766719AbXEBQsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766734AbXEBQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:48:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766719AbXEBQsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:48:10 -0400
Date: Wed, 2 May 2007 09:47:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-Id: <20070502094707.4197ab7a.akpm@linux-foundation.org>
In-Reply-To: <20070502104413.GC4392@one.firstfloor.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<p733b2gzqkg.fsf@bingen.suse.de>
	<20070501220803.GA27698@Krystal>
	<20070502104413.GC4392@one.firstfloor.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 12:44:13 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > It is currently used as an instrumentation infrastructure for the LTTng
> > tracer at IBM, Google, Autodesk, Sony, MontaVista and deployed in
> > WindRiver products.  The SystemTAP project also plan to use this type of
> > infrastructure to trace sites hard to instrument. The Linux Kernel
> > Markers has the support of Frank C. Eigler, author of their current
> > marker alternative (which he wishes to drop in order to adopt the
> > markers infrastructure as soon as it hits mainline).
> 
> All of the above don't use mainline kernels.

That's because they have to add a markers patch!

> That doesn't constitute using it.

Andi, there was a huge amount of discussion about all this in September last
year (subjects: *markers* and *LTTng*). The outcome of all that was, I
believe, that the kernel should have a static marker infrastructure.
