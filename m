Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbXFDNZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbXFDNZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXFDNZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:25:23 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:59168 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbXFDNZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:25:21 -0400
Date: Mon, 4 Jun 2007 09:25:11 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       James Carter <jwcart2@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [bug] very high non-preempt latency in context_struct_compute_av()
In-Reply-To: <20070604112745.GA26350@elte.hu>
Message-ID: <Line.LNX.4.64.0706040924040.11109@d.namei>
References: <20070604112745.GA26350@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Ingo Molnar wrote:

> 
> a simple ssh login triggers a ~130 msecs non-preemptible latency even 
> with CONFIG_PREEMPT enabled, on a fast Core2Duo CPU (!).

Thanks for the report.

> 
> the latency is caused by a _very_ long loop in the SELinux code:
> 
>     sshd-4828  0.N.. 465894us : avtab_search_node (context_struct_compute_av)

What do the 0DNs fields mean and what did you use to create this trace?


- James
-- 
James Morris
<jmorris@namei.org>
