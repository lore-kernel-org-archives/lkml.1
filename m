Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXK1Ok0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXK1Ok0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXK1OkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:40:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbXK1OkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:40:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071128084914.GA28486@linux-sh.org>
References: <20071128084914.GA28486@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@snapgear.com>,
       David McCullough <david_mccullough@au.securecomputing.com>,
       linux-kernel@vger.kernel.org
Subject: Re: nommu: Add new vmalloc_user() and remap_vmalloc_range() interfaces.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 Nov 2007 14:39:57 +0000
Message-ID: <15288.1196260797@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> This builds on top of the earlier vmalloc_32_user() work introduced by
> b50731732f926d6c49fd0724616a7344c31cd5cf, as we now have places in the
> nommu allmodconfig that hit up against these missing APIs.
> 
> As vmalloc_32_user() is already implemented, this is moved over to
> vmalloc_user() and simply made a wrapper. As all current nommu platforms
> are 32-bit addressable, there's no special casing we have to do for
> ZONE_DMA and things of that nature as per GFP_VMALLOC32.
> 
> remap_vmalloc_range() needs to check VM_USERMAP in order to figure out
> whether we permit the remap or not, which means that we also have to
> rework the vmalloc_user() code to grovel for the VMA and set the flag.

Acked-by: David Howells <dhowells@redhat.com>
