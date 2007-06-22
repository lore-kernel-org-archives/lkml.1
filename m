Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbXFVTBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbXFVTBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760553AbXFVTBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:01:00 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28327 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbXFVTA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:00:59 -0400
Date: Fri, 22 Jun 2007 21:00:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] mmc-atmel : fix kunmap wrong usage
Message-ID: <20070622190015.GM30033@kernel.dk>
References: <467A4532.40301@rfo.atmel.com> <200706211657.49427.marc.pignat@hevs.ch> <467A9F43.1050007@rfo.atmel.com> <200706220828.18750.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706220828.18750.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22 2007, Marc Pignat wrote:
> from: Marc Pignat <marc.pignat@hevs.ch>
> 
> kunmap must be called on the pointer returned by kmap.

kunmap_atomic() should align the given buffer to the start of the page
anyway, so your patch wont change behaviour.

-- 
Jens Axboe

