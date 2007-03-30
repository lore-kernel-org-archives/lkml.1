Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXC3Tjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXC3Tjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXC3Tjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:39:41 -0400
Received: from gw.goop.org ([64.81.55.164]:50797 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbXC3Tjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:39:40 -0400
Message-ID: <460D6778.6000207@goop.org>
Date: Fri, 30 Mar 2007 12:39:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>,
       =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: smart gcc inliner...
References: <46093349.7060401@agmk.net> <p73ircm4odz.fsf@bingen.suse.de> <4609D92A.3050104@goop.org> <20070330193216.GJ14134@stusta.de>
In-Reply-To: <20070330193216.GJ14134@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Mar 27, 2007 at 07:55:38PM -0700, Jeremy Fitzhardinge wrote:
>   
>> Andi Kleen wrote:
>>     
>>> init functions should only ever be called from other init functions.
>>>
>>> So this should not happen. If it happens the annotations need to be fixed.
>>>       
>> I've seen some versions of gcc inline weak functions too.
>>     
>
> Please be more precise:
> - gcc version
> - example code
> - bug number in the gcc Bugzilla
>   

Sorry, it was a while ago, and I didn't take the time to fully report
it.  It was FC6 on x86_64, doing a 32-bit cross-build.  I'll see if I
can repro it.

> This would also help understanding what you are talking about:
> - Did gcc inline a global function?
> - Or was a static function declared as weak (which might be an error
>   by the programmer)?
> - ...
>   

It was, specifically, smp_setup_processor_id getting inlined into
start_kernel.

    J
