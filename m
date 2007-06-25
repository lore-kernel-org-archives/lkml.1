Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbXFYTLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbXFYTLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXFYTK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:10:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbXFYTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:10:58 -0400
Date: Mon, 25 Jun 2007 12:09:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Andi Kleen <ak@suse.de>, eranian@hpl.hp.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Message-Id: <20070625120926.0a86373c.akpm@linux-foundation.org>
In-Reply-To: <20070620183448.GB3251@atjola.homenet>
References: <20070618103214.GA12045@atjola.homenet>
	<200706201431.44014.ak@suse.de>
	<20070620124959.GB24906@frankl.hpl.hp.com>
	<200706201501.02582.ak@suse.de>
	<20070620183315.GA3251@atjola.homenet>
	<20070620183448.GB3251@atjola.homenet>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 20:34:48 +0200
Bj__rn Steinbrink <B.Steinbrink@gmx.de> wrote:

> The performance counter allocator relies on the nmi watchdog being
> probed, so we have to do that even if the watchdog is not enabled.
> 

So...  what's the status of this lot?

I've just merged this patch and the second one:

Subject: [PATCH 2/2] Reserve the right performance counter for the Intel PerfMon NMI watchdog
Message-ID: <20070620183551.GC3251@atjola.homenet>

but there was no followup discussion afaict.

Andi, Stephane: acks?

If acked, do we agree that this is 2.6.22 material?

Thanks.
