Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXLTWzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXLTWzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXLTWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:55:00 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46246 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbXLTWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:55:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: peerchen@gmail.com, linux-kernel@vger.kernel.org, acurrid@nvidia.com,
       pchen@nvidia.com
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability
References: <200712182300373901202@gmail.com>
	<20071219164125.a3eac8ba.akpm@linux-foundation.org>
	<20071219164555.1916fa42.akpm@linux-foundation.org>
Date: Thu, 20 Dec 2007 15:54:07 -0700
In-Reply-To: <20071219164555.1916fa42.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 19 Dec 2007 16:45:55 -0800")
Message-ID: <m17ij97zao.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 19 Dec 2007 16:41:25 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> It would be better to just add a stub implementation of
>> ht_enable_msi_mapping() for all the other architectures - avoid fancy cpp
>> tricks.
>
>
> And by this I really do mean going into each include/asm-*/pci.h and adding
>
>
> struct pci_dev;		(if needed)
> ...
>
> static inline void ht_enable_msi_mapping(struct pci_dev *dev)
> {
> }
>
>
> no macros, no ifdef tricks, no include tricks.  Just straight, clean, fully
> typechecked C.

Andrew thanks for the code style review.  I goofed about recommending the
ARCH_HAVE_XXXX thing.

I'm going to concentrate on the content for the moment.  I think we
are very close to a general solution to a very common problem with
MSI interrupts.

Eric
