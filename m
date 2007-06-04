Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbXFDTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbXFDTDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbXFDTDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:03:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40192 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758349AbXFDTDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:03:00 -0400
Date: Mon, 4 Jun 2007 12:02:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __get_free_pages:  can GFP_DMA omit GFP_KERNEL and GFP_ATOMIC?
In-Reply-To: <Pine.LNX.4.64.0706041449470.3148@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706041201210.24550@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706030435130.14627@localhost.localdomain>
 <Pine.LNX.4.64.0706041143520.24412@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706041449470.3148@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Robert P. J. Day wrote:

> all right, then some of those __get_free_pages() calls would translate
> to calls of the form __get_dma_pages(0, ...) -- is that what you're
> saying?  or would it be equivalent and preferable to put GFP_ATOMIC in
> there just so it looks not so weird?

Put GFP_ATOMIC in there so that it does not look weird.

GFP_ATOMIC & ~__GFP_HIGH == GFP_NOWAIT

So these should have GFP_NOWAIT as far as I can tell?

