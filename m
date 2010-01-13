Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806Ab0AMPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0AMPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224Ab0AMPl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:41:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0AMPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:41:57 -0500
X-Authority-Analysis: v=1.0 c=1 a=xpLpJGNBBNoA:10 a=7U3hwN5JcxgA:10 a=dm3pRbNqHM6X-_Mu1SIA:9 a=kd_tJaiLV7LY-f9REdUA:7 a=zhpf4LOhasn_2DU29zJrFUZBP04A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 14/26] trace: Convert various locks to raw_spinlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1001131632350.5665@localhost.localdomain>
References: <1263245216-14754-7-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
	 <20100112033931.GF5243@nowhere> <20100113152824.GA15301@goodmis.org>
	 <alpine.LFD.2.00.1001131632350.5665@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 13 Jan 2010 10:41:55 -0500
Message-ID: <1263397315.28171.3827.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 16:36 +0100, John Kacur wrote:
> 
> On Wed, 13 Jan 2010, Steven Rostedt wrote:

> > 
> Thanks for the review Steve and Frederic - I'll spin a new patch that 
> doesn't convert tracing_start_lock.
> 
> However, let's give it some good testing in preempt-rt, because we may 
> have forgotten over time, why we converted these locks.

Well, I think we just never unconverted them :-)  I think we took the
paranoid approach and converted all locks in the trace directory to raw.
In fact, I think I even had a script to do it.

-- Steve


