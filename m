Return-Path: <linux-kernel-owner+w=401wt.eu-S2993061AbXDYUQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993061AbXDYUQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993062AbXDYUQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:16:39 -0400
Received: from 1wt.eu ([62.212.114.60]:2271 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993061AbXDYUQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:16:38 -0400
Date: Wed, 25 Apr 2007 22:13:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Li, Tong N" <tong.n.li@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425201309.GA5646@1wt.eu>
References: <20070424212717.GR31925@holomorphy.com> <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com> <20070425094403.GA3290@elte.hu> <20070425115840.GT31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425115840.GT31925@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:58:40AM -0700, William Lee Irwin III wrote:

> Adjustments to the lag computation for for arrivals and departures
> during execution are among the missing pieces. Some algorithmic devices
> are also needed to account for the varying growth rates of lags of tasks
> waiting to run, which arise from differing priorities/weights.

that was the principle of my proposal of sorting tasks by expected completion
time and using +/- credit to compensate for too large/too short slice used.

Willy

