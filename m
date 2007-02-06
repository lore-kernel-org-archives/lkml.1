Return-Path: <linux-kernel-owner+w=401wt.eu-S1030588AbXBFXmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588AbXBFXmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030578AbXBFXmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:42:20 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37055 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030588AbXBFXmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:42:19 -0500
Message-ID: <45C9125A.3040704@vmware.com>
Date: Tue, 06 Feb 2007 15:42:18 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/11] Sched clock paravirt op
References: <200702060352.l163qeAf000727@zach-dev.vmware.com> <20070206123256.GF47229@muc.de> <45C9056A.8060504@vmware.com> <45C90DDA.3060009@goop.org>
In-Reply-To: <45C90DDA.3060009@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Scheduled (or available) time and real time are good notions.  Stolen
>> time is debatable.  But TSC is basically just always wrong.  That's
>> why I don't want to overload the rdtsc operation. 
>>     
> Well, in the Xen case it is actually guaranteed to be correct and useful
> as real time, but that's definitely not something we can expect in
> general.  But you're talking specifically about schedulable vcpu time
> here, right?
>   

Not schedulable time, scheduled time (schedulable - scheduled) = stolen

Zach

