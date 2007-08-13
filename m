Return-Path: <linux-kernel-owner+w=401wt.eu-S938042AbXHMGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938042AbXHMGEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXHMGE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:04:29 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:33928 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753893AbXHMGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:04:28 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 8/9] Memory controller add switch to control what
 type of pages to limit (v4)
In-Reply-To: Your message of "Mon, 13 Aug 2007 11:08:58 +0530"
	<46BFEE72.9080209@linux.vnet.ibm.com>
References: <46BFEE72.9080209@linux.vnet.ibm.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070813060427.0334E1BF9D8@siro.lan>
Date: Mon, 13 Aug 2007 15:04:26 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> YAMAMOTO Takashi wrote:
> >> Choose if we want cached pages to be accounted or not. By default both
> >> are accounted for. A new set of tunables are added.
> >>
> >> echo -n 1 > mem_control_type
> >>
> >> switches the accounting to account for only mapped pages
> >>
> >> echo -n 2 > mem_control_type
> >>
> >> switches the behaviour back
> > 
> > MEM_CONTAINER_TYPE_ALL is 3, not 2.
> > 
> 
> Thanks, I'll fix the comment on the top.
> 
> > YAMAMOTO Takashi
> > 
> >> +enum {
> >> +	MEM_CONTAINER_TYPE_UNSPEC = 0,
> >> +	MEM_CONTAINER_TYPE_MAPPED,
> >> +	MEM_CONTAINER_TYPE_CACHED,

what's MEM_CONTAINER_TYPE_CACHED, btw?
it seems that nothing distinguishes it from MEM_CONTAINER_TYPE_MAPPED.

YAMAMOTO Takashi
