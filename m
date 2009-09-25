Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbZIYJkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbZIYJkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIYJkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZIYJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:40:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4ABC4CAB.7090302@np.css.fujitsu.com>
References: <4ABC4CAB.7090302@np.css.fujitsu.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: dhowells@redhat.com, LKLM <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney " <paulmck@linux.vnet.ibm.com>,
       =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Patch x86-tip] Clean up the warning message about RCU not defined
Date: Fri, 25 Sep 2009 10:39:28 +0100
Message-ID: <11766.1253871568@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jin Dongming <jin.dongming@np.css.fujitsu.com> wrote:

> (This fix is for commit 4765c1db84c73f775eb1822a009117cbae524e9e
>    Titled "rcu-tiny: The Bloatwatch Edition, v6")
> 
> When the kernel is built, there is some message printed as
> following:
>     include/linux/rcupdate.h:80:7: \
>         warning: "CONFIG_TINY_RCU" is not defined
> 
> So I did "grep _RCU .config" to search the information of "CONFIG_TINY_RCU"
> in .config file and the result is listed as following:
>     Command:
>         grep _RCU .config
>     Result:
>         CONFIG_TREE_RCU=y
>         # CONFIG_TREE_PREEMPT_RCU is not set
>         # CONFIG_TINY_RCU is not set
>         CONFIG_RCU_TRACE=y
>         CONFIG_RCU_FANOUT=64
>         # CONFIG_RCU_FANOUT_EXACT is not set
>         CONFIG_TREE_RCU_TRACE=y
>         # CONFIG_RCU_TORTURE_TEST is not set
>         # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> 
> Though the "WARNING" does not give impact to build kernel, I think
> it should be cleaned up. And I made the patch for modifying it.
> With this patch there is not any other warning message of
> CONFIG_TINY_RCU and the kernel could be built successfully. And I
> confirmed that the built kernel works well.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>

Acked-by: David Howells <dhowells@redhat.com>
