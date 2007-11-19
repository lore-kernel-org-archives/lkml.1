Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXKSNne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXKSNne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXKSNnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:43:21 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:53227 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754792AbXKSNnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:43:20 -0500
Date: Mon, 19 Nov 2007 22:43:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: even *more* unused CONFIG variables at no extra charge
Message-ID: <20071119134316.GA12158@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.9999.0711160555530.13454@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711160555530.13454@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 06:15:48AM -0500, Robert P. J. Day wrote:
> ==== sh64 ====
> >>>>> DEVICE_MEMORY_START
> >>>>> FLASH_MEMORY_START
> >>>>> HDSP253_LED
> >>>>> PCI_BLOCK_START
> >>>>> PCIDEVICE_MEMORY_START

Yeah, these are mostly bogus and just never got removed. I'll poke
through it and kill them off or fix up the Makefiles to actually use
them (as in the HDSP253_LED case). Thanks for catching these, these sorts
of reports are really useful.

Have you considered tidying up your config checker and adding it as a
static analyser target with the existing set? 'make configcheck' or
something would be a reasonable addition.
