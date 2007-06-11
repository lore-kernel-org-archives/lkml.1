Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXFKPjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXFKPjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXFKPj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:39:27 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59798 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbXFKPjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:39:25 -0400
Date: Tue, 12 Jun 2007 00:38:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:3689!
Message-ID: <20070611153804.GA26209@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Christoph Lameter <clameter@sgi.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 04:19:26PM +0200, Haavard Skinnemoen wrote:
> I think the combination that triggered this bug was:
>   * CONFIG_SLUB_DEBUG=y
>   * ARCH_KMALLOC_MINALIGN=32
>   * slub_debug not set at the command line
> 
ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN are both in bytes
(ARCH_KMALLOC_MINALIGN used to be defined as BYTES_PER_WORD) if I recall
correctly, are you sure this is what you want?
