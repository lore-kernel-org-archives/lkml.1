Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZIDEgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZIDEgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZIDEgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:36:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48729
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbZIDEgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:36:47 -0400
Date: Thu, 03 Sep 2009 21:37:02 -0700 (PDT)
Message-Id: <20090903.213702.250776705.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       mingo@elte.hu
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090817064851.GQ12579@kernel.dk>
References: <20090806070242.GF12579@kernel.dk>
	<20090816.183134.90977928.davem@davemloft.net>
	<20090817064851.GQ12579@kernel.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Mon, 17 Aug 2009 08:48:51 +0200

>     sparc: add basic support for 'perf'
>     
>     This wires up the perf_counter_open() syscall so that basic
>     software support for perf is working.
>     
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Does this build for you without adding an
arch/sparc/include/asm/perf_counter.h that looks
something like the following?

#ifndef _ASM_SPARC_PERF_COUNTER_H
#define _ASM_SPARC_PERF_COUNTER_H

#define PERF_COUNTER_INDEX_OFFSET	0

#endif

Or is this somehow now required in the -tip trees?
