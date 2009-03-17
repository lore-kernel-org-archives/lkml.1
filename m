Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZCQN0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZCQN0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZCQN0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:26:14 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:64828 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZCQN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:26:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
 cpuacct_charge() safe when rcupreempt is used.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090317131251.GU16897@balbir.in.ibm.com>
References: <20090317061754.GD3314@in.ibm.com>
	 <49BF42FB.4030103@cn.fujitsu.com> <20090317073649.GH3314@in.ibm.com>
	 <20090317131251.GU16897@balbir.in.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 14:26:01 +0100
Message-Id: <1237296361.7867.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 18:42 +0530, Balbir Singh wrote:

> I'd like to get the patches in -tip and see the results, I would
> recommend using percpu_counter_sum() while reading the data as an
> enhancement to this patch. If user space does not overwhelm with a lot
> of reads, sum would work out better.

You trust userspace? I'd rather not.

