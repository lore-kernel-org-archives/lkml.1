Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZHJPbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZHJPbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZHJPbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:31:42 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:58109 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZHJPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:31:41 -0400
Date: Mon, 10 Aug 2009 17:31:27 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090810153127.GB23319@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810141442.GA18456@braap.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> I've had a closer look; it seems to me that most of it is unnecessary;
> there's no show those lists to a driver. I'd just provide a single
> 'do_dma(attributes)' call that sleeps until it's done (or similar).

s/there's no show/there's no point in showing/

Basically the driver simply shouldn't care about these DMA
lists. It just wants to get the work done, no matter how.

E.
