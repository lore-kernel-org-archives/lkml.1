Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZHKUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZHKUs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZHKUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:48:57 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:56086 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZHKUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:48:56 -0400
Date: Tue, 11 Aug 2009 22:48:35 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090811204835.GA9910@braap.org>
References: <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com> <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com> <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com> <20090811153633.GC32658@braap.org> <4A819130.5080802@gefanuc.com> <20090811154226.GD32658@braap.org> <4A819E80.90103@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A819E80.90103@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> need for both approaches. It may be more efficient for a driver to use  
> and move 1 window to position it's self over the registers of each of a  
> number of compatible devices as required.

No, drivers should know nothing about the bridge. The *very* same
driver should run on different crates, different configurations,
different bridges.

The bridge should be intelligent enough to handle the driver's
mapping requests in an efficient way; it's basically the only
job of the bridge: to serve efficiently the driver's needs.
And, sorry to repeat myself, he's the only player entitled to
do so. "Because he knows better."

FWIW, our driver does exactly that. Will post it fairly soon,
but I want to test it with the new changes first.

Best wishes,
E.
