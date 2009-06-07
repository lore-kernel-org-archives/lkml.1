Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZFGNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZFGNk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbZFGNkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:40:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33804 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZFGNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:40:14 -0400
Date: Sun, 7 Jun 2009 15:40:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: Re: [PATCH 0/5 v3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090607134009.GE12088@elte.hu>
References: <20090603142727.GI5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603142727.GI5736@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Changes to previous patch set:
> - remove MULTI_NODE_CPU config option
> - provide defaults for cpu_node topology information
> - add patch to fix AMD mcheck code
> 
> Current patch set contains 5 patches:
> - patch 1 adapts common code to show cpu_node_id,
>   cpu_node_siblings and cpu_node_siblings_list in
>   /sys/devices/system/cpu/cpu*/topology
> - patch 2 prepares arch/x86 to provide cpu_node information
> - patch 3 sets up cpu_node information for AMD Magny-Cours CPU
> - patch 4 fixes L3 cache information for Magny-Cours
> - patch 5 fixes mcheck code for Magny-Cours

it would be really nice to propagate this info to where it _really_ 
matters: the sched-domains topology info - unless i'm missing 
something this patch-set does not do that yet, right? That way we'll 
get actual feedback if it's broken, and will help people if it works 
right. Device allocation matters too, but to a much lesser degree.

	Ingo
