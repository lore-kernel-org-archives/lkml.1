Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbXFDSqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbXFDSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbXFDSpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:45:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39305 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758350AbXFDSpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:45:53 -0400
Date: Mon, 4 Jun 2007 11:45:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __get_free_pages:  can GFP_DMA omit GFP_KERNEL and GFP_ATOMIC?
In-Reply-To: <Pine.LNX.4.64.0706030435130.14627@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706041143520.24412@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706030435130.14627@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Robert P. J. Day wrote:

>   first, can a call to __get_free_pages to allocate DMA-able memory
> omit specifying either of GFP_KERNEL or GFP_ATOMIC?  love's book on
> kernel development strongly suggests you need to specify one or the
> other, but there are a few instances in the tree like this:

Sure that seems to be equivalent to GFP_ATOMIC with no access to emergency 
pool memory.

>   and, second, i only noticed this as i was going to submit a short
> patch to replace __get_free_pages calls for DMA-able memory with the
> existing equivalent macro __get_dma_pages.  is that still considered a
> worthwhile cleanup?  there's not that many examples of it, and it
> would just make things consistent.

Sure.
