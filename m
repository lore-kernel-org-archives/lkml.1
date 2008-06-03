Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYFCR5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYFCR5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYFCR5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:57:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20054 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYFCR53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:57:29 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5309"; a="3470595"
Message-ID: <48458604.3040804@qualcomm.com>
Date: Tue, 03 Jun 2008 10:57:24 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, suresh.b.siddha@intel.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <20080602164203.GA2477@sgi.com> <48443E66.6060205@qualcomm.com> <20080602214151.GA7072@sgi.com> <48446D46.2010903@qualcomm.com> <20080603144010.GA25948@sgi.com>
In-Reply-To: <20080603144010.GA25948@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> On Mon, Jun 02, 2008 at 02:59:34PM -0700, Max Krasnyansky wrote:
>> Yes it used to be somewhat unstable. These days it solid. I'm using it on a
>> wide range of systems: uTCA Core2Duo, NUMA dual-Opteron, 8way Core2, etc. And
>> things work as expected.
> 
> Max,
> 
> I tried the following scenario on an ia64 Altix running 2.6.26-rc4 with
> cpusets compiled in but cpuset fs unmounted. Do your patches already address this?
Nope. My patch was a trivial fix for not destroying scheduler domains on 
hotplug events. The problem you're seeing is different.

I'm not an expert in cpu hotplug internal machinery especially on ia64. Recent 
kernels (.22 and up) I've tried on x86 and x86-64 have no issues with cpu 
hotplug. You probably want to submit a bug report (in a separate thread) maybe 
it's a regression in the latest .26-rc series.

Max

