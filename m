Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956Ab0ANMZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0ANMZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853Ab0ANMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:25:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0ANMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:25:38 -0500
Subject: Re: [PATCH 3/6] perf: Round robin groups of events using
 list_rotate_left()
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1263087500-14215-4-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
	 <1263087500-14215-4-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:25:22 +0100
Message-ID: <1263471922.4244.311.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 02:38 +0100, Frederic Weisbecker wrote:
> This is more proper that doing it through a list_for_each_entry()
> that breaks after the first entry.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> ---

> +	list_rotate_left(&ctx->pinned_groups);
> +	list_rotate_left(&ctx->flexible_groups);

Just wondering, pinned events were supposed to be on the pmu at all
times, right?

