Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbXFZWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbXFZWWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXFZWWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:22:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:40249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbXFZWWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:22:10 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: dma_mapping_ops for i386
Date: Wed, 27 Jun 2007 00:21:11 +0200
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46817016.7090400@goop.org>
In-Reply-To: <46817016.7090400@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706270021.11434.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 21:59, Jeremy Fitzhardinge wrote:
> I'm looking at adding dom0 support to the pv-ops kernel.  One of the
> obvious things we need is to support real device drivers, and the
> associated p->m translations for devices.
>
> I'm thinking the cleanest thing to do is make x86-64's dma-mapping.h
> with its dma_mapping_ops common to i386 and x86-64, so we can hook the
> Xen translations in there.  Presumably we'll need to do this anyway to
> support VTd for 32-bit (but I don't know if that's a reasonable thing to
> do anyway).
>
> What do you think?

Ok, if you can do it without ifdefs. 

And no swiotlb on i386; that is something that is completely broken
in upstream Xen and needs to be fixed properly anyways.

-Andi
