Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYAIOVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYAIOVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYAIOVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:21:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:60345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYAIOVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:21:32 -0500
From: Andi Kleen <ak@suse.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other achitectures and kill notifier cruft"
Date: Wed, 9 Jan 2008 15:23:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: hch@lst.de, airlied@linux.ie, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, pq@iki.fi, jbeulich@novell.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie> <20080109071727.GA10695@lst.de> <20080108.232223.211829980.davem@davemloft.net>
In-Reply-To: <20080108.232223.211829980.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091523.35845.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You can set a kprobe on the x86 fault handler to do things like
> mmiotrace.

That would mean that if the kprobe faults it goes into an endless loop.
Most of do_page_fault() is not really safe for kprobes.

-Andi

