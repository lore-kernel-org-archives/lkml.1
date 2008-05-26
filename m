Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYEZIxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYEZIxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYEZIx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:53:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYEZIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:53:25 -0400
Date: Mon, 26 May 2008 01:52:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Message-Id: <20080526015232.5faac5bb.akpm@linux-foundation.org>
In-Reply-To: <20080526084709.GA2182@elte.hu>
References: <20080524165828.GA29993@elte.hu>
	<20080524104024.a33116a3.akpm@linux-foundation.org>
	<483A7663.4000700@jp.fujitsu.com>
	<20080526084709.GA2182@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 10:47:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> 
> > I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with 
> > some other patches for the other pciehp regression problems.
> 
> looks good to me, thanks Kenji.
> 

It's a bit sad to add a large workaround like this.  I'm surprised
that fixing it properly is considered unviable for 2.6.26.  Normally
these fixes are pretty simple - just request the IRQ a bit later?

