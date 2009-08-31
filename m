Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbZHaLLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbZHaLLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZHaLLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:11:48 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:34679 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZHaLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:11:48 -0400
Date: Mon, 31 Aug 2009 16:41:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 5/5] memcg: drain per cpu stock
Message-ID: <20090831111146.GJ4770@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132809.ad7cfebc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090828132809.ad7cfebc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:28:09]:

> 
> Add function for dropping per-cpu stock of charges.
> This is called when
> 	- cpu is unplugged.
> 	- force_empty
> 	- recalim seems to be not easy.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

The complexity of this patch and additional code make percpu_counter
more attractive. Why not work on percpu_counter if that is not as good
as we expect it to be and in turn help other exploiters as well.
-- 
	Balbir
