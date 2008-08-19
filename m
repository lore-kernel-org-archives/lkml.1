Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYHSRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYHSRQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYHSRQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:16:40 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:17269 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYHSRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:16:39 -0400
Message-ID: <48AAFFF0.7020405@colorfullife.com>
Date: Tue, 19 Aug 2008 19:16:32 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, mingo@elte.hu
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@tv-sign.ru,
       dipankar@in.ibm.com, rostedt@goodmis.org, dvhltc@us.ibm.com,
       niv@us.ibm.com
Subject: nohz_cpu_mask question (was: Re: [PATCH tip/core/rcu] classic RCU
 locking and memory-barrier cleanups)
References: <20080805162144.GA8297@linux.vnet.ibm.com> <489936E5.7020509@colorfullife.com> <20080807031806.GA6910@linux.vnet.ibm.com> <48A93D49.2000601@colorfullife.com> <20080818140404.GD6847@linux.vnet.ibm.com> <48AAA501.8010502@colorfullife.com> <20080819140339.GF7106@linux.vnet.ibm.com>
In-Reply-To: <20080819140339.GF7106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

can someone explain me nohz_cpu_mask?

If I understand it correctly, it merely means that this cpu does not 
take timer interrupts, correct?
The cpu can still take "real" interupts, e.g. a nic interrupt. The cpu 
could also do softirq processing.

Is that correct? Ingo?

If nohz cpus can take normal interrupts, then it would be wrong to 
exclude these cpus from the mask of cpus that must pass a quiescent 
cycle - a softirq could hold on a pointers.

--
    Manfred
