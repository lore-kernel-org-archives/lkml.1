Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYLENaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYLENaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLENao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:30:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58593 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLENao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:30:44 -0500
Message-ID: <58995.10.75.179.61.1228483840.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081205212529.8d895526.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
    <20081205212529.8d895526.nishimura@mxp.nes.nec.co.jp>
Date: Fri, 5 Dec 2008 22:30:40 +0900 (JST)
Subject: Re: [RFC][PATCH -mmotm 4/4] memcg: change try_to_free_pages 
     tohierarchical_reclaim
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> mem_cgroup_hierarchicl_reclaim() works properly even when !use_hierarchy
> now,
> so, instead of try_to_free_mem_cgroup_pages(), it should be used in many
> cases.
>
> The only exception is force_empty. The group has no children in this case.
>
Hmm...I postponed this until removing cgroup_lock from reclaim..
But ok, this is a way to go,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



