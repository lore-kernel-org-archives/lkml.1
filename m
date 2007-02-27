Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXB0L6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXB0L6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXB0L6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:58:33 -0500
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:42344 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933051AbXB0L6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:58:33 -0500
In-Reply-To: <1172558897.11949.43.camel@localhost.localdomain>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> <1172448057.3971.9.camel@shinybook.infradead.org> <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou> <1172558897.11949.43.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul TBBle Hampson <Paul.Hampson@Pobox.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: Make sure we populate the initroot filesystem late enough
Date: Tue, 27 Feb 2007 12:58:28 +0100
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I've not been able to reproduce it since, but I know others (BCC'ed 
>>> on
>>> this note) have seen it and might prod them to come forth with 
>>> details
>>> (and broken .config files)
>>
>> In my case, disabling CPU_FREQ_PMAC made the failure go away.
>> After reverting this patch, CPU_FREQ_PMAC is once again operating
>> successfully, so far.
>
> Hrm.. which cpufreq method is used on both your machines ? If it's the
> one involving the PMU, it does involve a full hard reset of the
> processor (with appropriate cache flushes etc...), maybe something's
> going wrong in that area....

It's most likely a red herring, lots of config changes
make the bug go away on some kernel versions (but not
on others); the problem is very sensitive to changes in
memory layout.


Segher

