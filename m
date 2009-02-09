Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZBIIUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZBIIUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZBIIUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:20:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbZBIIUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:20:22 -0500
Date: Mon, 9 Feb 2009 00:19:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
Message-Id: <20090209001903.89548108.akpm@linux-foundation.org>
In-Reply-To: <20090209081124.GB24420@elte.hu>
References: <498CB0B7.8030009@kernel.org>
	<20090206140005.44b4bb50.akpm@linux-foundation.org>
	<498CB4DC.2010108@kernel.org>
	<498D3D15.5090005@kernel.org>
	<20090207002610.73ff7e6d.akpm@linux-foundation.org>
	<86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com>
	<20090207010619.daededa3.akpm@linux-foundation.org>
	<20090209081124.GB24420@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 09:11:24 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 7 Feb 2009 01:01:03 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > 
> > > add kzalloc_node_safe()?
> > 
> > I cannot find that function.
> 
> His suggestion is to provide that allocator variant.
> 

Oh.

It isn't possible to write a kzalloc_node_safe(GFP_ATOMIC).  Or at
least, we've never worked out a way.

Maybe I'm confused again.
