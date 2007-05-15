Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXEOEsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXEOEsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbXEOEsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:48:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760192AbXEOEse convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:48:34 -0400
Date: Mon, 14 May 2007 21:48:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Luis =?ISO-8859-1?B?VuF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [ARM] Fix hard_smp_processor_id compile error
Message-Id: <20070514214818.16b36610.akpm@linux-foundation.org>
In-Reply-To: <1179197981.4519.2.camel@sebastian.intellilink.co.jp>
References: <20070515022014.CC2A44F910@tabatha.lab.ultramonkey.org>
	<1179197981.4519.2.camel@sebastian.intellilink.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 11:59:41 +0900 Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

> On Tue, 2007-05-15 at 11:18 +0900, Simon Horman wrote: 
> > "Remove hardcoding of hard_smp_processor_id on UP systems",
> > 2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
> > the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
> > for UP systems. This causes a regression on ARM as the definition
> > was not added to asm-arm/smp.h.
> Hi Simon!
> 
> Thank you for catching and fixing these compile errors. I should install
> a cross-compiler ASAP.

Mine are at http://userweb.kernel.org/~akpm/cross-compilers/
