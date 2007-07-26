Return-Path: <linux-kernel-owner+w=401wt.eu-S933600AbXGZQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbXGZQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761519AbXGZQZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:25:49 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36505 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761056AbXGZQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:25:47 -0400
Message-ID: <46A8CB13.1020306@bull.net>
Date: Thu, 26 Jul 2007 18:25:55 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] flush icache before set_pte on ia64 take3
References: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>	<46A8BA30.7000508@bull.net> <20070727010825.a5934cb0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070727010825.a5934cb0.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 18:30:29,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 18:30:30,
	Serialize complete at 26/07/2007 18:30:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> Thank you for advise. Hmm..how about this ?
> ==
>  /*
>   * synchronize icache and dcache if the hardware doesn't do it automatically
>   * and the page is executable.
>   */
> static inline arch_sync_icache_dcache(pte_t pte, page) {
> 
> }

Why not?

I just wanted to see if you change the existing interface or not.

Thanks,

Zoltan
