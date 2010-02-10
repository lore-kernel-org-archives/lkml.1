Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0BJQRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:17:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0BJQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:17:33 -0500
Subject: Re: [perfmon2] [PATCH] perf_events: AMD event scheduling (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Drongowski, Paul" <paul.drongowski@amd.com>, eranian@gmail.com,
       perfmon2-devel@lists.sf.net, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net
In-Reply-To: <bd4cb8901002100807y7b142f02ofb8cecb507ddf681@mail.gmail.com>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
	 <1265803166.11509.286.camel@laptop>
	 <bd4cb8901002100504i8e716e8ob845f692e031726f@mail.gmail.com>
	 <1265807830.11509.295.camel@laptop> <1265808501.11509.300.camel@laptop>
	 <7c86c4471002100558s1a744ae7h6b3837c786e03704@mail.gmail.com>
	 <6096959DEF5C9447A6BF80BDC7EB9EDC14913E8B@SBOSEXMB1.amd.com>
	 <bd4cb8901002100807y7b142f02ofb8cecb507ddf681@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 17:17:17 +0100
Message-ID: <1265818637.11509.309.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 17:07 +0100, Stephane Eranian wrote:
> 
> static inline int amd_is_nb_event(struct hw_perf_event *hwc)
> {
>    return (hwc->config >> 5) & 0x7 == 0x7;
> }

return (hwc->config & 0xe0) == 0xe0;

Changed it, thanks guys!

