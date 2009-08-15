Return-Path: <linux-kernel-owner+w=401wt.eu-S1751132AbZHOI7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbZHOI7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 04:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZHOI7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 04:59:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51384 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZHOI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 04:59:06 -0400
Message-ID: <4A8678C4.4060309@cs.helsinki.fi>
Date: Sat, 15 Aug 2009 11:58:44 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, Arnaldo Carvalho de Melo <acme@redhat.com>,
       paulus@samba.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] perf_counter: Report the cloning task as parent on perf_counter_fork()
References: <1250155708.6052.2.camel@penberg-laptop> <1250172882.5241.62.camel@twins>
In-Reply-To: <1250172882.5241.62.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> A bug in (9f498cc: perf_counter: Full task tracing) makes profiling
> multi-threaded apps it go belly up.

Thanks!

Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>

I hope the fix makes it to 2.6.31 final as perf is unusable for 
multi-threaded applications.

			Pekka
