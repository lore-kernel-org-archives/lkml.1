Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbXCWWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbXCWWZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932738AbXCWWZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:25:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXCWWZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:25:34 -0400
Message-ID: <46045355.1020105@redhat.com>
Date: Fri, 23 Mar 2007 18:23:17 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David L <idht4n@hotmail.com>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	 <20070323185028.GR752@stusta.de> <1174677338.10840.321.camel@localhost.localdomain>
In-Reply-To: <1174677338.10840.321.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
>> Subject    : gettimeofday increments too slowly
>> References : http://bugzilla.kernel.org/show_bug.cgi?id=8027
>> Submitter  : David L <idht4n@hotmail.com>
>> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>>              commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2
>> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>> Status     : problem is being debugged
> 
> Patch available: http://lkml.org/lkml/2007/3/22/301
> 
> commit 6b3964cde70cfe6db79d35b42137431ef7d2f7e4
> 

For the other issue raised there, clock running too slow, I now
realize there is a similar report:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=231626

