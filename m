Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYL2MZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYL2MZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYL2MZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:25:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58321 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYL2MZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:25:02 -0500
Date: Mon, 29 Dec 2008 13:24:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Indan Zupancic <indan@nul.nu>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race in ring_buffer_consume(): Replace
	ring_buffer_consume and ring_buffer_peek with ring_buffer_get_event
Message-ID: <20081229122449.GG9628@elte.hu>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl> <1230536044-14847-1-git-send-email-indan@nul.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230536044-14847-1-git-send-email-indan@nul.nu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Indan Zupancic <indan@nul.nu> wrote:

> Original mail was mangled, patch resent via git.
> 
> Signed-off-by: Indan Zupancic <indan@nul.nu>
> ---
>  include/linux/ring_buffer.h   |    4 +---
>  kernel/trace/ring_buffer.c    |   39 ++++++++-------------------------------
>  kernel/trace/trace.c          |   15 ++++++++-------
>  kernel/trace/trace_selftest.c |    2 +-
>  4 files changed, 18 insertions(+), 42 deletions(-)

there's been a number of updates here - could you please do a patch 
against tip/master:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
