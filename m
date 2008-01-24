Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYAXVAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYAXVAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbYAXVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:00:35 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13939 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYAXVAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:00:34 -0500
Date: Thu, 24 Jan 2008 12:58:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
Message-Id: <20080124125845.bf5767b8.randy.dunlap@oracle.com>
In-Reply-To: <20080124203335.082459062@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
	<20080124203335.082459062@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 15:27:13 -0500 Mathieu Desnoyers wrote:

> Add initialization of an array, which needs brackets that would pollute kernel
> code, to kernel.h. It is used to declare arguments passed as function parameters

Hi Mathieu,

Maybe you have explained this previously, but please give a short
explanation of "brackets that would pollute kernel code".

Thanks.

> such as:
> text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  include/linux/kernel.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6-lttng.mm/include/linux/kernel.h
> ===================================================================
> --- linux-2.6-lttng.mm.orig/include/linux/kernel.h	2008-01-24 14:10:54.000000000 -0500
> +++ linux-2.6-lttng.mm/include/linux/kernel.h	2008-01-24 14:23:06.000000000 -0500
> @@ -423,4 +423,6 @@ struct sysinfo {
>  #define NUMA_BUILD 0
>  #endif
>  
> +#define INIT_ARRAY(type, val, len) ((type [len]) { [0 ... (len)-1] = (val) })
> +
>  #endif

---
~Randy
