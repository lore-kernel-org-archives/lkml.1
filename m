Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbXCaKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbXCaKCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXCaKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:02:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54023 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXCaKCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:02:13 -0400
Date: Sat, 31 Mar 2007 12:02:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com
Subject: Re: exposing FSB clock speed in /sys
Message-ID: <20070331100209.GA17761@one.firstfloor.org>
References: <20070330153937.GC16059@frankl.hpl.hp.com> <p73bqiaqh32.fsf@bingen.suse.de> <20070331081832.GB17535@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331081832.GB17535@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I am not interested in older processors, but I think for all recent Intel
> processors, there is a fairly simple algorithm to get the frequency using
> a couple of MSRs (including MSR_IA32_EBL_CR_POWERON or MSR_FSB_FREQ).

Hmm, maybe make it an own driver that creates the sysfs entries somewhere.
I don't think it's useful enough for the main kernel.

But what happens during power saving that may lower the frequency? 
Wouldn't you need update events for that? That might complicate it.

> 
> Don't we already have /sys entries that exits only for certain processors
> or platforms?

Yes.

> I think the Opteron have HYPERTRANSPORT-related events which could be used
> to obtain similar metrics.

Yes, but you usually don't need the frequency.

-Andi
