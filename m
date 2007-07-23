Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbXGWTFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbXGWTFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760034AbXGWTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:05:12 -0400
Received: from ns.suse.de ([195.135.220.2]:53440 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbXGWTFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:05:11 -0400
To: Tong Li <tong.n.li@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jul 2007 22:00:02 +0200
In-Reply-To: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
Message-ID: <p73ir8aubzx.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tong Li <tong.n.li@intel.com> writes:
> +
> +        read_lock_irqsave(&dwrr_highest_lock, flags);

That lock looks like it would bounce between CPUs like crazy.
Did you try any benchmarks on a larger system? 

-Andi
