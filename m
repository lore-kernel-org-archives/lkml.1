Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZABWff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZABWff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZABWfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:35:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbZABWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:35:11 -0500
Date: Fri, 2 Jan 2009 17:35:08 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: 2.6.27/2.6.28: irqbalance dies shortly after starting the
	daemon on x86 but not x86_64, why?
Message-ID: <20090102223508.GA5181@bombadil.infradead.org>
References: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 07:26:30AM -0500, Justin Piszcz wrote:
> (same on both x86 and x86_64):
> # cat /etc/default/irqbalance
> #Configuration for the irqbalance daemon
>
> #Should irqbalance be enabled?
> ENABLED=1
> #Balance the IRQs only once?
> ONESHOT="0"
>

If there is only one cache domain, ie: one physical cpu socket with two
cores sharing a cache, then irqbalance will return after the initial
balance since it would be pointless to continue running. (It forces
itself into oneshot mode.)

regards, Kyle
