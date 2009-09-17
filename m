Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbZIQHpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbZIQHpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbZIQHpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:45:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57349 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZIQHpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:45:34 -0400
Subject: Re: +
 generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB1A652.1010000@cn.fujitsu.com>
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>
	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>
	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>
	 <4AADEF2F.5080504@cn.fujitsu.com>
	 <1252973802.2899.88.camel@sbs-t61.sc.intel.com>
	 <4AAEF5DC.4070308@cn.fujitsu.com>
	 <1253067602.2667.13.camel@sbs-t61.sc.intel.com>
	 <4AB1A652.1010000@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 09:45:16 +0200
Message-Id: <1253173516.14935.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 11:00 +0800, Xiao Guangrong wrote:
> Waiting all cpu handle its IPI interruption in stop_machine() path will make 
> it slower, I'm not sure it's OK.

It is, its an absolute slow path.

