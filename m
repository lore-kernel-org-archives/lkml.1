Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXKZK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXKZK2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbXKZK2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:28:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40859 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbXKZK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:28:24 -0500
Date: Mon, 26 Nov 2007 19:19:49 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] mm/sparse.c: Improve the error handling for sparse_add_one_section()
Cc: Dave Hansen <haveblue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
In-Reply-To: <20071123055150.GA2488@hacking>
References: <1195507022.27759.146.camel@localhost> <20071123055150.GA2488@hacking>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071126191316.99CF.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Cong-san.

>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  
>  	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
>  
>  out:
>  	pgdat_resize_unlock(pgdat, &flags);
> -	if (ret <= 0)
> -		__kfree_section_memmap(memmap, nr_pages);
> +
>  	return ret;
>  }
>  #endif

Hmm. When sparse_init_one_section() returns error, memmap and 
usemap should be free.

Thanks for your fixing.

-- 
Yasunori Goto 


