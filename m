Return-Path: <linux-kernel-owner+w=401wt.eu-S1030606AbXBFXsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030606AbXBFXsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030607AbXBFXsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:48:12 -0500
Received: from gw.goop.org ([64.81.55.164]:57652 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030606AbXBFXsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:48:10 -0500
Message-ID: <45C913B6.4080701@goop.org>
Date: Tue, 06 Feb 2007 15:48:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/11] Sched clock paravirt op
References: <200702060352.l163qeAf000727@zach-dev.vmware.com> <20070206123256.GF47229@muc.de> <45C9056A.8060504@vmware.com> <45C90DDA.3060009@goop.org> <45C9125A.3040704@vmware.com>
In-Reply-To: <45C9125A.3040704@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
>> Zachary Amsden wrote:
>>  
>>> Scheduled (or available) time and real time are good notions.  Stolen
>>> time is debatable.  But TSC is basically just always wrong.  That's
>>> why I don't want to overload the rdtsc operation.     
>> Well, in the Xen case it is actually guaranteed to be correct and useful
>> as real time, but that's definitely not something we can expect in
>> general.  But you're talking specifically about schedulable vcpu time
>> here, right?
>>   
>
> Not schedulable time, scheduled time (schedulable - scheduled) = stolen

I meant "schedulable" (perhaps "usable" would be better) from the
guest's perspective: total amount of real cpu time each vcpu gets.  ie:
(real - schedulable) = stolen.  So I think we're talking about the same
thing.

    J
