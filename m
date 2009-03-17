Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZCRAAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZCRAAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZCRAAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:00:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54573 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZCRAAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:00:36 -0400
Date: Wed, 18 Mar 2009 08:59:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
 cpuacct_charge() safe when rcupreempt is used.
Message-Id: <20090318085908.215f665d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1237296361.7867.16.camel@twins>
References: <20090317061754.GD3314@in.ibm.com>
	<49BF42FB.4030103@cn.fujitsu.com>
	<20090317073649.GH3314@in.ibm.com>
	<20090317131251.GU16897@balbir.in.ibm.com>
	<1237296361.7867.16.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 14:26:01 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-03-17 at 18:42 +0530, Balbir Singh wrote:
> 
> > I'd like to get the patches in -tip and see the results, I would
> > recommend using percpu_counter_sum() while reading the data as an
> > enhancement to this patch. If user space does not overwhelm with a lot
> > of reads, sum would work out better.
> 
> You trust userspace? I'd rather not.
> 
hehe, I don't trust, either.
BTW, is there anyone wants "remove rq->lock" patch ?
If yes, I'll dig the patch from my graveyard.

Thanks,
-Kame

