Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbYBMX2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbYBMX2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbYBMX2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:28:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758786AbYBMX2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:28:15 -0500
Date: Wed, 13 Feb 2008 15:28:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 8/8] IPMI: Convert locked counters to atomics in the
 system interface
Message-Id: <20080213152805.2a1a3316.akpm@linux-foundation.org>
In-Reply-To: <20080213163432.GH9830@minyard.local>
References: <20080213163432.GH9830@minyard.local>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:34:32 -0600
Corey Minyard <minyard@acm.org> wrote:

> +struct smi_stats
> +{
> +	atomic_t short_timeouts;
> +	atomic_t long_timeouts;
> +	atomic_t timeout_restarts;
> +	atomic_t idles;
> +	atomic_t interrupts;
> +	atomic_t attentions;
> +	atomic_t flag_fetches;
> +	atomic_t hosed_count;
> +	atomic_t complete_transactions;
> +	atomic_t events;
> +	atomic_t watchdog_pretimeouts;
> +	atomic_t incoming_messages;
> +};

Ditto.


Also, please do remember to check all patches with scripts/checkpatch.pl.  I can
see one right there.

