Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYJQC55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYJQC55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYJQC5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:57:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40339
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbYJQC5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:57:46 -0400
Date: Thu, 16 Oct 2008 19:57:22 -0700 (PDT)
Message-Id: <20081016.195722.148509014.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [RFC patch 03/15] get_cycles() : sparc64 HAVE_GET_CYCLES
 (update)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081017024824.GB32468@Krystal>
References: <20081016232729.699004293@polymtl.ca>
	<20081016234655.893647148@polymtl.ca>
	<20081017024824.GB32468@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 16 Oct 2008 22:48:24 -0400

> This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
> get_cycles_rate() are implemented.
> 
> Changelog :
> - Use tb_ticks_per_usec * 1000000 in get_cycles_rate().
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Yep, that'll work:

Acked-by: David S. Miller <davem@davemloft.net>
