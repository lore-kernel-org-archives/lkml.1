Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZBBUvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZBBUvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZBBUuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:50:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZBBUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:50:53 -0500
Subject: Re: hackbench [pthread mode] regression with 2.6.29-rc3
From: Peter Zijlstra <peterz@infradead.org>
To: Bryon Roche <kain@kain.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <gm7bmu$uo$1@ger.gmane.org>
References: <1233473426.2604.13.camel@ymzhang>
	 <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
	 <1233476961.13659.12.camel@minggr.sh.intel.com>
	 <1233479836.4787.63.camel@laptop> <1233482239.4787.65.camel@laptop>
	 <1233537134.2604.24.camel@ymzhang> <1233564818.4787.107.camel@laptop>
	 <gm7bmu$uo$1@ger.gmane.org>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 21:50:48 +0100
Message-Id: <1233607848.10184.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 17:49 +0000, Bryon Roche wrote:

don't drop CCs

> On Mon, 02 Feb 2009 09:53:38 +0100, Peter Zijlstra wrote:
> 
> > On Mon, 2009-02-02 at 09:12 +0800, Zhang, Yanmin wrote:
> > 
> > I would rather go back to the old model where we iterate all threads,
> > and find a way to not make programs with too many threads for their own
> > good lock up the kernel, but instead get poor service.
> 
> Now, there's an interesting question, what is the definition of too many
> threads for a program's own good?  When evaluating this, please assume 
> that you
> do actually have enough RAM to keep thread stacks/other userspace 
> threading
> resources in-core.

In my book a program has too many threads when it outnumbers the number
of cpus available to it by an order of so.



