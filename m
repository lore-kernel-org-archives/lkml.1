Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZLCVeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZLCVeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZLCVeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:34:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:33144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZLCVeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:34:21 -0500
Subject: Re: [PATCH 2/2] hw-breakpoints: Add two reserved fields for future
 extensions
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1259874964-7757-2-git-send-regression-fweisbec@gmail.com>
References: <1259874964-7757-1-git-send-regression-fweisbec@gmail.com>
	 <1259874964-7757-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 22:33:39 +0100
Message-ID: <1259876019.3977.1559.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 22:16 +0100, Frederic Weisbecker wrote:

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 771d04c..89832cc 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -221,6 +221,8 @@ struct perf_event_attr {
>  			__u64		bp_end;
>  			__u32		bp_type;
>  			__u32		bp_len;
> +			__u64		__bp_reserved_1;
> +			__u64		__bp_reserved_2;
>  		};
>  	};

Looking at that code I see:

 union {
  struct {
  }
 }

wth is that union for?

