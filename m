Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836Ab0ALTii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0ALTii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776Ab0ALTih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:38:37 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44935 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab0ALTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:38:36 -0500
Date: Tue, 12 Jan 2010 13:32:43 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
In-Reply-To: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001121331590.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 Jan 2010, Yinghai Lu wrote:

> on x86, before prefill_possible_map(), nr_cpu_ids will be NR_CPUS aka CONFIG_NR_CPUS
>
> add nr_cpus= to set nr_cpu_ids. so we can simulate cpus <=8 on normal config.
> instead of change NR_CPUS directly.

We already have

maxcpus=x?

Why do we need this twice?

