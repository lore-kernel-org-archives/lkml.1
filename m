Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801Ab0ATSdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0ATSdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577Ab0ATSdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:33:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46874 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0ATSdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:33:00 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Andi Kleen <andi@firstfloor.org>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	<20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	<1263467289.4244.288.camel@laptop>
	<1263498366.4875.25.camel@localhost.localdomain>
	<1263546228.4244.343.camel@laptop> <20100115093831.GC26396@in.ibm.com>
	<1263549014.4244.374.camel@laptop> <4B53213C.9050303@redhat.com>
	<1263739939.557.20938.camel@twins> <4B5325CF.5000001@redhat.com>
	<1263740593.557.20967.camel@twins> <4B53661A.9090907@redhat.com>
	<1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	<1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	<1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	<1263816857.4283.381.camel@laptop>
Date: Wed, 20 Jan 2010 19:32:57 +0100
In-Reply-To: <1263816857.4283.381.camel@laptop> (Peter Zijlstra's message of "Mon, 18 Jan 2010 13:14:17 +0100")
Message-ID: <87ska039uu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> With CPL2 or RPL on user segments the protection issue seems to be
> manageable for running the instructions from kernel space. 

Nope -- it doesn't work on 64bit and even on 32bit can have large
costs on some CPUs.

Also designing 32bit only features in 2010 would seem rather ....
unfortunate.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
