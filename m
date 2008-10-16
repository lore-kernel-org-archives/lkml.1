Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYJPKoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYJPKoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYJPKnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:43:51 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:41885 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYJPKnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:43:51 -0400
Subject: Re: [PATCH] Enable console on PCI serial devices
From: Paul Bolle <pebolle@tiscali.nl>
To: n0ano@n0ano.com
Cc: Yinghai Lu <yinghai@kernel.org>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20081015204850.GC14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
	 <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
	 <20081014233031.GB14490@xolotl.n0ano.com>
	 <1224061999.25929.7.camel@test.thuisdomein>
	 <20081015204850.GC14490@xolotl.n0ano.com>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 12:43:42 +0200
Message-Id: <1224153822.3587.23.camel@test.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 (2.24.0-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 14:48 -0600, n0ano@n0ano.com wrote:
> On Wed, Oct 15, 2008 at 11:13:19AM +0200, Paul Bolle wrote:
> As an aside, I would personally be in favor of removing the `earlycon'
> kernel parameter entirely, it seems to be a strict subset of the
> `console' parameter and anyone that wants `earlycon' probably wants
> `console' anyway.  Is there a strong argument for keeping that
> parameter that I'm missing?

The same thing puzzles me too. Note that earlyprintk=serial|ttyS?[...]
also provides a similar feature.

>        earlycon=       [KNL] Output early console device and options.
>-               uart[8250],io,<addr>[,options]
>-               uart[8250],mmio,<addr>[,options]
>+               uart[8250],io,<addr>[,options,[clkd]]
>+               uart[8250],mmio,<addr>[,options,[clkd]]

clkd?


Paul Bolle

