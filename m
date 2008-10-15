Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYJONo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYJONo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYJONos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:44:48 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:63026 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbYJONor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:44:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAAeQ9UhMQWq+/2dsb2JhbACBcr9rgWs
Date: Wed, 15 Oct 2008 09:44:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] markers: let marker_table be close
	to its comments
Message-ID: <20081015134446.GB29281@Krystal>
References: <48F5942F.4080400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48F5942F.4080400@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:44:28 up 132 days, 18:24,  9 users,  load average: 0.34, 0.49,
	0.53
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> marker_table is defined far from its comments, this fix make
> cleanup for it.
> 

Good idea! Thanks.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/marker.c b/kernel/marker.c
> index e9c6b2b..e49a9c5 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -43,6 +43,7 @@ static DEFINE_MUTEX(markers_mutex);
>   */
>  #define MARKER_HASH_BITS 6
>  #define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
> +static struct hlist_head marker_table[MARKER_TABLE_SIZE];
>  
>  /*
>   * Note about RCU :
> @@ -67,8 +68,6 @@ struct marker_entry {
>  	char name[0];	/* Contains name'\0'format'\0' */
>  };
>  
> -static struct hlist_head marker_table[MARKER_TABLE_SIZE];
> -
>  /**
>   * __mark_empty_function - Empty probe callback
>   * @probe_private: probe private data
> 
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
