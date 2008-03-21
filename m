Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYCUUHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYCUUHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYCUUG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:06:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:36070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYCUUGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:06:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,537,1199692800"; 
   d="scan'208";a="537845733"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Fri, 21 Mar 2008 13:04:42 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE1391B@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Thread-Index: AciLgeGmlJ9gLPKsRDayVF0qKv9/HwAASXbwAALTdtA=
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> 
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Jens Axboe" <jens.axboe@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, <npiggin@suse.de>, <paulus@samba.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>
X-OriginalArrivalTime: 21 Mar 2008 20:04:50.0236 (UTC) FILETIME=[D1D95FC0:01C88B8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem may be worse than that.  I see that you have a per-cpu
> "call_single_queue" on which you do some list operations.

Simply hacking in an early call to init_call_single_data() helped
a bit.  I saw a few more kernel messages as all the cpus were
brought up and synchronized ITC with the boot cpu. Then the
system hung hard.  Last messages were:

Total of 16 processors activated (50724.86 BogoMIPS).
net_namespace: 296 bytes
DMI 2.3 present




-Tony
