Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbXKAPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbXKAPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbXKAPHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:07:13 -0400
Received: from sacred.ru ([62.205.161.221]:50546 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbXKAPHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:07:11 -0400
Message-ID: <4729EB88.6080408@openvz.org>
Date: Thu, 01 Nov 2007 18:06:48 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>  <4729E7E4.8070208@openvz.org> <1193928977.27652.289.camel@twins>
In-Reply-To: <1193928977.27652.289.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 01 Nov 2007 18:06:46 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2007-11-01 at 17:51 +0300, Pavel Emelyanov wrote:
> 
>>  So can we, please, 
>> keep things as they are for now - the appropriate fix will be ready 
>> soon.
> 
> Just for the curious, could you outline on how you intend to fix this?

I have already answered to Ulrich about this. Just to
make this sub-thread consistent:

The "fix" I mention is just returning -EINVAL in case user orders 
CLONE_NEWPIDS and compiling out all the namespace cloning code. This 
is just a more elegant way to get rid of pid namespaces rather than 
Ingo proposed.

Here's the root of the set:
http://lkml.org/lkml/2007/10/31/118

Thanks,
Pavel
