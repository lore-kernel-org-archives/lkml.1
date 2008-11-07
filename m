Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYKGNbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYKGNbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYKGNbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:31:38 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43598 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:31:38 -0500
Date: Fri, 7 Nov 2008 22:21:08 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: Re: [RFC][PATCH 5/6] memcg: mem+swap controller
Message-Id: <20081107222108.9f7152c2.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081105172316.354c00fb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
	<20081105172316.354c00fb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1286,30 +1507,33 @@ static int mem_control_stat_show(struct 
>  		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
>  
>  	}
> +	/* showing refs from disk-swap */
> +	cb->fill(cb, "swap_on_disk", atomic_read(&mem_cont->swapref)
> +					* PAGE_SIZE);
>  	return 0;
>  }
>  
"if (do_swap_account)" is needed here too.


Thanks,
Daisuke Nishimura.
