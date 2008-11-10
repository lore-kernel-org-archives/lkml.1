Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYKJSur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYKJSur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYKJSug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:50:36 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:44817 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbYKJSuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:50:35 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v3 0/5] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 19:50:16 +0100
Message-Id: <1226343016.7685.444.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a quick response, I'll read them more carefully tomorrow:

 - why are the preferred cpu things pointers? afaict using just the cpu
number is both smaller and clearer to the reader.

 - in patch 5/5 you do:

+               spin_unlock(&this_rq->lock);
+               double_rq_lock(this_rq, busiest);

we call that double_lock_balance()

 - comments go like:

 /*
  * this is a multi-
  * line comment
  */



