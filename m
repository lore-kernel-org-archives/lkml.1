Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118Ab0AUKgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0AUKgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943Ab0AUKgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:36:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0AUKgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:36:40 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:36:21 +0100
Message-ID: <1264070181.4283.1149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 10:58 +0200, Stephane Eranian wrote:
>  void hw_perf_enable(void)
>  {


> +               cpuc->n_added = 0;
> +               perf_events_lapic_init();

Just wondering, why do we need that lapic_init() there?

> +       }
>         x86_pmu.enable_all();
>  } 

