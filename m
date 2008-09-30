Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYI3IOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYI3IOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYI3IOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:14:25 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34157 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220AbYI3IOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:14:24 -0400
Message-ID: <48E1DFDC.4000706@linux.vnet.ibm.com>
Date: Tue, 30 Sep 2008 13:44:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] memcg: avoid account not-on-LRU pages
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com> <20080929192339.327ca142.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080929192339.327ca142.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> +		if (charged)
> +			mem_cgroup_uncharge_page(page);
> +		if (anon) {
>  			page_cache_release(page);
> -		else
> +		} else
>  			anon = 1; /* no anon but release faulted_page */
>  	}

Coding style braces for a single-line if-else, please recheck

-- 
	Balbir
