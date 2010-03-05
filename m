Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0CEIow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 03:44:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57529 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0CEIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 03:44:51 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 05/11] perf: Generic perf_sample_data initialization
Date: Fri, 5 Mar 2010 09:44:19 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       Jamie Iles <jamie.iles@picochip.com>,
       "David S. Miller" <davem@davemloft.net>, stable@kernel.org
References: <20100303163936.906011640@chello.nl> <20100303164306.222595079@chello.nl>
In-Reply-To: <20100303164306.222595079@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003050944.20032.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 03 March 2010 17:39:41 Peter Zijlstra wrote:
> This makes it easier to extend perf_sample_data and fixes a bug on
> arm and sparc, which failed to set ->raw to NULL, which can cause
> crashes when combined with PERF_SAMPLE_RAW.
>
> It also optimizes PowerPC and tracepoint, because the struct
> initialization is forced to zero out the whole structure.
>
> CC: Jamie Iles <jamie.iles@picochip.com>
> CC: Jean Pihet <jpihet@mvista.com>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: David S. Miller <davem@davemloft.net>
> CC: Stephane Eranian <eranian@google.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: stable@kernel.org
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Jean Pihet <jpihet@mvista.com>

Thanks!



