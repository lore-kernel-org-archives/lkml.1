Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZHTLqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZHTLqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZHTLqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:46:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:38089 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZHTLqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fDRbA2W4s12Nvpq35IoxzmvWvY5ebgL/zMFpczNkVl++X2NoX9wcxresb7J2k4ysAX
         yQeH4EhjQrdBU5Q/sc5QtbXRgizj+EtuWRKA6Zi23X+R8uxkLNGJ43d8gaiMULOYLJim
         YUm57bHC5EHSze5kK631I6nHBHXVSSbPCeVRA=
MIME-Version: 1.0
In-Reply-To: <20090820062451.GH21100@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	 <20090512193656.D647.A69D9226@jp.fujitsu.com>
	 <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten>
	 <20090820051038.GF21100@kryten>
	 <20090820052605.GC26265@balbir.in.ibm.com>
	 <1250747579.8282.110.camel@twins> <20090820060528.GG21100@kryten>
	 <20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090820062451.GH21100@kryten>
Date: Thu, 20 Aug 2009 17:16:03 +0530
X-Google-Sender-Auth: 8fa3861a990f8e2f
Message-ID: <661de9470908200446m74df2939n506568b57aae5993@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch 
	values for stats counters
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Anton,

Do you have any data on what level of batching is good for
VIRT_CPU_ACCOUNTING? If it is going to be as high as INT_MAX, then
your patch seems to be the best way to go forward. We'll need to herd
away bad users who read cpuacct.stat frequently enough to create a
problem.

Balbir Singh.
