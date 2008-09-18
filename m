Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYIREoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYIREoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYIREoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:44:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38277 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYIREoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:44:00 -0400
Date: Thu, 18 Sep 2008 13:50:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com,
       dave@linux.vnet.ibm.com, nickpiggin@yahoo.com.au, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page (v3)
Message-Id: <20080918135023.99cac1d0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080918.132613.74431429.taka@valinux.co.jp>
References: <20080911105638.1581db90.kamezawa.hiroyu@jp.fujitsu.com>
	<20080917232826.GA19256@balbir.in.ibm.com>
	<20080917184008.92b7fc4c.akpm@linux-foundation.org>
	<20080918.132613.74431429.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 13:26:13 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:


> But I think each memory model type should have its own way of managing
> its page_cgroup arrays as doing for its struct page arrays.
> It would be better rather than the sparsemem approach he said.
> 
My patch adds an interface. Then...
FLATMEM support will be very easy.
I'll ignore DISCONTIGMEM and SPARSEMEM (they will use my 'hash')
SPARSEMEM_VMEMMAP support will took some amount of time. It will need
per-arch patches.

Thanks,
-Kame

