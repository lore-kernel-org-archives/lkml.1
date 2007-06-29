Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbXF2DWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbXF2DWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764983AbXF2DWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:22:23 -0400
Received: from gw.goop.org ([64.81.55.164]:34569 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927AbXF2DWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:22:23 -0400
Message-ID: <46847AB5.5040704@goop.org>
Date: Thu, 28 Jun 2007 23:21:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22-rc3-mm1: Xen compile error with X86_CMPXCHG=n
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070602135711.GB5500@stusta.de> <20070628233659.GE6087@stusta.de>
In-Reply-To: <20070628233659.GE6087@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>> Adding a dependency of XEN on X86_CMPXCHG should not be a problem and 
>> not prevent any reasonable real-life usage.
>>
>> But what worries me is that a seemingly architecture independent 
>> driver uses a function only available in some configurations.
>>     
>
> Still present as of 2.6.22-rc6-mm1.

Sorry, must have missed this one.   Um, yeah, I guess we have a 
dependency on cmpxchg.  I'll do a patch.

    J

