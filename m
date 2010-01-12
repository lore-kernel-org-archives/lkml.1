Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609Ab0ALDMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0ALDMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067Ab0ALDMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:12:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853Ab0ALDMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:12:48 -0500
Date: Mon, 11 Jan 2010 19:06:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] use nr_cpus= to set nr_cpu_ids early
In-Reply-To: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1001111906120.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jan 2010, Yinghai Lu wrote:
>
> on x86, before prefill_possible_map(), nr_cpu_ids will be NR_CPUS aka CONFIG_NR_CPUS
> 
> add nr_cpus= to set nr_cpu_ids. so we can simulate cpus <=8 on normal config.
> instead of change NR_CPUS directly.

Looks sane.

		Linus
