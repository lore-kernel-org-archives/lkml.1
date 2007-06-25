Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbXFYTiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbXFYTiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXFYTiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:38:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:58895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXFYTiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:38:08 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Date: Mon, 25 Jun 2007 21:36:17 +0200
User-Agent: KMail/1.9.1
Cc: =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com
References: <20070618103214.GA12045@atjola.homenet> <20070620183448.GB3251@atjola.homenet> <20070625120926.0a86373c.akpm@linux-foundation.org>
In-Reply-To: <20070625120926.0a86373c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706252136.18366.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2007 21:09, Andrew Morton wrote:
> On Wed, 20 Jun 2007 20:34:48 +0200
>
> Bj__rn Steinbrink <B.Steinbrink@gmx.de> wrote:
> > The performance counter allocator relies on the nmi watchdog being
> > probed, so we have to do that even if the watchdog is not enabled.
>
> So...  what's the status of this lot?
>
> I've just merged this patch and the second one:
>
> Subject: [PATCH 2/2] Reserve the right performance counter for the Intel
> PerfMon NMI watchdog Message-ID: <20070620183551.GC3251@atjola.homenet>
>
> but there was no followup discussion afaict.
>
> Andi, Stephane: acks?

Yes, although I'm still a little uneasy about the always probe one.

> If acked, do we agree that this is 2.6.22 material?

The first (always probe) is probably .22 material, but needs more testing 
first.

-Andi
