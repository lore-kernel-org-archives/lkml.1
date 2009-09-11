Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZIKHvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZIKHvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZIKHvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:51:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZIKHvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:51:04 -0400
Subject: Re: +
 generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AAA0001.2060703@cn.fujitsu.com>
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>
	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:50:45 +0200
Message-Id: <1252655445.7126.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 15:45 +0800, Xiao Guangrong wrote:
> CPU A call smp_call_function_many(wait=0) that want CPU B to call

Ah, right, the .wait=0 is the clue, that makes all this
get/put_onlines_cpus() useless..

You're right, carry on ;-)

