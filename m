Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbXC0Lmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbXC0Lmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 07:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXC0Lmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 07:42:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbXC0Lmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 07:42:33 -0400
Message-ID: <460902CF.1030202@redhat.com>
Date: Tue, 27 Mar 2007 07:41:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com,
       Thilo.Cestonaro.external@fujitsu-siemens.com
Subject: Re: [PATCH]: Fix bogus softlockup warning with sysrq-t
References: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com> <4608AF01.4060804@goop.org>
In-Reply-To: <4608AF01.4060804@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I have another pair of softlockup patches in which I try to address:
>
>     * ignoring time stolen by hypervisors
>     * threads going to sleep tickless for long periods of time
>
>   

I'm looking at the code now.  Your solution is definately better :)

> I could easy add a "global disable" function, which would allow long
> sysrq messages, and it would help Thilo with his long flash update freezes.
>
>   

I think that's a good idea -- I'll propose an add on patch to fix the 
sysrq-t case ...

P.

>     J
>   
