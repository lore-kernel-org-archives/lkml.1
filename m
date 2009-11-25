Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbZKYTfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbZKYTfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbZKYTfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:35:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759588AbZKYTfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:35:46 -0500
Date: Wed, 25 Nov 2009 11:35:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philip Langdale <philipl@overt.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Port ricoh_mmc from driver to pci quirk.
Message-Id: <20091125113501.1f4d42b9.akpm@linux-foundation.org>
In-Reply-To: <20091125085324.1ef9ae1f@fido2.homeip.net>
References: <1259021583.16650.9.camel@maxim-laptop>
	<20091123162119.3777e14d@fido2.homeip.net>
	<1259160947.10147.1.camel@maxim-laptop>
	<1259161121.10147.4.camel@maxim-laptop>
	<20091125085324.1ef9ae1f@fido2.homeip.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 08:53:24 -0800
Philip Langdale <philipl@overt.org> wrote:

> On Wed, 25 Nov 2009 16:58:41 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > >From 5c5e6f5ab1a5a09a430f410cab4b160a5e65501c Mon Sep 17 00:00:00
> > >2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Wed, 25 Nov 2009 16:37:46 +0200
> > Subject: [PATCH] Port ricoh_mmc from driver to pci quirk.
> >  This is much cleaner and correct solution

This patch actually fixes a bug but the changelog forgot to tell us
this important fact.

> I'm fine with the concept, but when I originally started work on
> Ricoh support, Pierre specifically didn't want a pci quirk.
> 
> Pierre wrote:
> > I'd rather we didn't. The current style of quirks are bad enough,
> > making them even more vendor or device specific is a bit more than I'm
> > willing to accept right now (seriously, how hard can it be to follow
> > the damn spec?).

Can the bug be fixed by other means, within ricoh_mmc.c?

It's a bit sad to add a lump of code to everyone's kernel like this -
what percentage of those machines actually have a ricoh mmc controller?

