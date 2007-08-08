Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbXHHKDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbXHHKDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbXHHKCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:48288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbXHHKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:03 -0400
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 13/25] [PATCH] turn msr.h functions into native versions
Date: Wed, 8 Aug 2007 11:25:37 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865468043920-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081125.38481.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 06:19, Glauber de Oliveira Costa wrote:

> +static __always_inline long long vget_cycles_sync(void)

Why is there a copy of this function now? That seems wrong

> +		native_read_tscp(&p);

The instruction is called rdtscp not read_tscp. Please follow that


> +#define rdtsc(low, high)			\

This macro can be probably eliminated, no callers in kernel


-Andi
