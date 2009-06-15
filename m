Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbZFOP5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbZFOP5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763382AbZFOP5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:57:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763573AbZFOP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:56:59 -0400
Date: Mon, 15 Jun 2009 08:56:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] MFD: Added Timberdale driver
Message-Id: <20090615085654.d8504527.akpm@linux-foundation.org>
In-Reply-To: <20090615101116.GB4094@sortiz.org>
References: <4A292099.2020306@mocean-labs.com>
	<20090615101116.GB4094@sortiz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 12:11:19 +0200 Samuel Ortiz <sameo@linux.intel.com> wrote:

> On Fri, Jun 05, 2009 at 03:41:45PM +0200, Richard R__jfors wrote:
> > MFD driver for the Timberdale FPGA The FPGA can be found on the
> > Intel Atom development board, Russellville for in-vechicle infotainment
> > 
> > The FPGA is connected via PCIe
> > 
> > The driver basically exposes a lot of platform devices for the
> > different IPs within the FPGA, and doing IRQ multiplexing
> > 
> > Signed-off-by: Richard R__jfors <richard.rojfors.ext@mocean-labs.com>
> patch #4 of this serie is an mfd driver too, so I guess I should have been
> cc'ed on it too.
> So, if I understand this thread correctly, we should proceed like that:
> 
> 1) Richard comes up with an updated xilinx patch (patch #2).
> 2) Andrew sends all patches but patch 7 to the relevant maintainers.
> 3) When all patches but 7 are in Linus tree, I take patch 7 and include it in
> my pull request to Linus.
> 
> Andrew, does that make sense to you? Do you want me to take patch #4 as well?

We could do it that way.  Or maintainers could just review-and-ack the
relevant patches and I could merge them.

