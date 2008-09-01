Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYIAGT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYIAGT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYIAGTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:19:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58682 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYIAGTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:19:49 -0400
Date: Mon, 1 Sep 2008 15:24:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080901152424.d9adfe47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48BB8716.5090805@linux.vnet.ibm.com>
References: <20080831174756.GA25790@balbir.in.ibm.com>
	<20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com>
	<48BB6160.4070904@linux.vnet.ibm.com>
	<20080901130351.f005d5b6.kamezawa.hiroyu@jp.fujitsu.com>
	<48BB8716.5090805@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2008 11:39:26 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:


> > The development of lockless-page_cgroup is not stalled. I'm just waiting for
> > my 8cpu box comes back from maintainance...
> > If you want to see, I'll post v3 with brief result on small (2cpu) box.
> > 
> 
> I understand and I am not pushing you to completing it, but at the same time I
> don't want to queue up behind it for long. I suspect the cost of porting
> lockless page cache on top of my patches should not be high, but I'll never know
> till I try :)
> 
My point is, your patch adds big lock. Then, I don't have to do meaningless effort
to reduce lock.

Thanks,
-Kame

