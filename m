Return-Path: <linux-kernel-owner+w=401wt.eu-S934330AbXCWXHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbXCWXHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934332AbXCWXHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:07:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934330AbXCWXHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:07:39 -0400
Message-ID: <46045D30.2020702@redhat.com>
Date: Fri, 23 Mar 2007 19:05:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David L <idht4n@hotmail.com>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185028.GR752@stusta.de> <1174677338.10840.321.camel@localhost.localdomain> <46045355.1020105@redhat.com> <20070323230021.GX752@stusta.de>
In-Reply-To: <20070323230021.GX752@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>>
>> For the other issue raised there, clock running too slow, I now
>> realize there is a similar report:
>>
>> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=231626
> 
> It shouldn't be the same issue:
> 2.6.20-1.2925.fc6 is based in 2.6.20.3-rc1 while this issue is a
> 2.6.21-rc regression.
> Or do the -rc kernels include parts of the -rt patchsets?
> 

Sometimes problems leak from the next kernel version into -stable
via the stable kernel patches.

Other times the bug may have been there all along but nobody had
found it yet...


