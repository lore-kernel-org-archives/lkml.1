Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZHKOt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZHKOt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZHKOt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:49:28 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:41916 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbZHKOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:49:28 -0400
Date: Tue, 11 Aug 2009 16:49:14 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090811144914.GB32658@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com> <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A812BCE.3010003@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> Again: what part of the API I have defined forces the driver to know  
> about the underlying bridge?

Let me answer with another question, maybe we get to understand
each other this way:

Could you please explain me what happens when 17 different drivers
want to control 17 different devices, each on a different slot,
same address modifier, only 1MB per device? Apply if necessary
to the tsi148 bridge.

NB1. Any given driver knows nothing about the other devices
on the crate; each driver only knows about the address, am and
size of the mapping for the device it controls--user-space
provide this info on a per-driver basis.
NB2. The mapping offsets configured through the cards' pins match
the information passed from user space to each of the cards.

Cheers,
E.
