Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYG3UId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYG3UId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYG3UIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:08:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12310 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbYG3UIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:08:10 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Roland Dreier <rdreier@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Date: Wed, 30 Jul 2008 20:07:28 +0000
Subject: RE: Problems building 2.6.26 and 2.6.27-rc1
Thread-Topic: Problems building 2.6.26 and 2.6.27-rc1
Thread-Index: Acjyd2E8khjUc+hJTDayTJzv3DKuAwAB7X1A
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3E811B0@GVW0547EXC.americas.hpqcorp.net>
References: <20080730184833.GA936@roadking.ldev.net>
 <adaiqunyyxd.fsf@cisco.com>
In-Reply-To: <adaiqunyyxd.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland wrote:

>
>  > I'm getting the following error when trying to build
> either 2.6.26 or  > 2.6.27-rc1:
>  >
>  > arch/x86/kernel/head64.c: In function 'x86_64_start_kernel':
>  > arch/x86/kernel/head64.c:88: error: size of array 'type
> name' is negative
>
> It looks like you're hitting
>
>         BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
>
> No idea why you're hitting that though.  What's your .config
> and compiler?
>
I think maybe I've figured out what's breaking my build. If use "make -jN" I hit the error. I usually set N to the number of processors (real and HT). So if /proc/cpuinfo display info about 4 processors I use -j4, etc. If I don't specify the number of jobs to run simultaneously the build completes with just the usual warnings.

Any experts on parallelism out there?

-- mikem
