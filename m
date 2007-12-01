Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbXLAJvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbXLAJvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 04:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXLAJvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 04:51:15 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43299 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbXLAJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 04:51:14 -0500
Message-ID: <47512E8D.6090805@linux.vnet.ibm.com>
Date: Sat, 01 Dec 2007 15:21:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, skumar@linux.vnet.ibm.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] sched: cpu accounting controller (V2)
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com> <20071129113035.bbdf35db.akpm@linux-foundation.org> <20071129201833.GA18023@linux.vnet.ibm.com> <20071130124225.GM5681@linux.vnet.ibm.com> <6599ad830711302348n49900ca8jfa66fa71fde76a67@mail.gmail.com>
In-Reply-To: <6599ad830711302348n49900ca8jfa66fa71fde76a67@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Hi Vatsa,
> 
> Thanks, this looks pretty good.
> 
> On Nov 30, 2007 4:42 AM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>>         - Removed load average information. I felt it needs more thought (esp
>>           to deal with SMP and virtualized platforms) and can be added for
>>           2.6.25 after more discussions.
> 
> The "load" value was never a load average, it was just a count of the
> % cpu time used in the previous fixed window of time, updated at the
> end of each window.
> 
> Maybe we can instead do something based tracking the length of the run
> queue for the cgroup?
> 
> Paul

Length of the runqueue gives no idea of the weight of the tasks on the
runqueue. I still prefer to have a top'ish view of the load on the
system. The load average can be extracted using container group statistics.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
