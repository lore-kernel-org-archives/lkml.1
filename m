Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0CCQtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:49:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33240
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830Ab0CCQtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:49:06 -0500
Date: Wed, 03 Mar 2010 08:49:25 -0800 (PST)
Message-Id: <20100303.084925.120000853.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       jamie.iles@picochip.com, jpihet@mvista.com, stable@kernel.org
Subject: Re: [RFC][PATCH 05/11] perf: Generic perf_sample_data
 initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100303164306.222595079@chello.nl>
References: <20100303163936.906011640@chello.nl>
	<20100303164306.222595079@chello.nl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 03 Mar 2010 17:39:41 +0100

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

Acked-by: David S. Miller <davem@davemloft.net>
