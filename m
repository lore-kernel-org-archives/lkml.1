Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXEOFXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXEOFXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 01:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXEOFWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 01:22:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904AbXEOFWy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 01:22:54 -0400
Date: Mon, 14 May 2007 22:22:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: Fernando Luis =?ISO-8859-1?B?VuF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [ARM] Fix hard_smp_processor_id compile error
Message-Id: <20070514222234.0eb5d149.akpm@linux-foundation.org>
In-Reply-To: <20070515045422.GD13708@verge.net.au>
References: <20070515022014.CC2A44F910@tabatha.lab.ultramonkey.org>
	<1179197981.4519.2.camel@sebastian.intellilink.co.jp>
	<20070514214818.16b36610.akpm@linux-foundation.org>
	<20070515045422.GD13708@verge.net.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 13:54:23 +0900 Simon Horman <horms@verge.net.au> wrote:

> On Mon, May 14, 2007 at 09:48:18PM -0700, Andrew Morton wrote:
> > On Tue, 15 May 2007 11:59:41 +0900 Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:
> > 
> > > On Tue, 2007-05-15 at 11:18 +0900, Simon Horman wrote: 
> > > > "Remove hardcoding of hard_smp_processor_id on UP systems",
> > > > 2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
> > > > the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
> > > > for UP systems. This causes a regression on ARM as the definition
> > > > was not added to asm-arm/smp.h.
> > > Hi Simon!
> > > 
> > > Thank you for catching and fixing these compile errors. I should install
> > > a cross-compiler ASAP.
> > 
> > Mine are at http://userweb.kernel.org/~akpm/cross-compilers/
> 
> Do you have / know of tools to create a set of configs for testing?
> What I am thinking of is something that takes the default configs,
> then toggles SMP, PREEMT and stuff like that, testing all the
> permutations.

`make randconfig'?
