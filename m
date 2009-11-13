Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZKMQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZKMQPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZKMQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:15:45 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:65517 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbZKMQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YPIOCgNUyW6CFZsBbtSf5+Asg9pToRQ4d5N2lOImP5PuDaECE4zjbNOF8At+s+FVIg
         d1bjLXZYSBdxqnWcqSVSZC0Jixec4wpxFVdEdclMtas6vY7WWfTSzEnN9R1gqjcVd51N
         76yfx/djjQ7AMcBNhpk6BdEMu4o6Zo4YILhAA=
Message-ID: <4AFD862E.6070105@gmail.com>
Date: Fri, 13 Nov 2009 11:15:42 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Stephen Hemminger <shemminger@vyatta.com>, sclark46@earthlink.net,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Documentation: rw_lock lessons learned
References: <4AF9C540.5090403@gmail.com>	<20091110180646.2e5859a8@nehalam>	<4AFAEF78.4080807@gmail.com>	<20091111093724.4f40a48d@nehalam>	<4AFBEC44.9030409@gmail.com>	<4AFC5E3F.7070609@earthlink.net> <20091112150029.1a26c641@nehalam> <4AFD1FF1.7080906@s5r6.in-berlin.de>
In-Reply-To: <4AFD1FF1.7080906@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Stephen Hemminger wrote:
>> On Thu, 12 Nov 2009 14:13:03 -0500
>> Stephen Clark <sclark46@earthlink.net> wrote:
>>> How up to date is this doc?
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/index.html
>>>
>> Out of date.
>> 1. Missing mutex's which have largely replaced semaphores.
>>
>> 2. Missing change to lock initialization in later kernels.
>>
>> 3. Missing description of lock dependency checker which should be in same guide.
> 
> 4. The section on atomic reference counting should refer to <linux/kref.h>.

I'd also read that, and that's where I got some of my wrong thinking.  But
that does point to Documentation/spin_locks.txt, which I took to be
authoritative (and followed).  That's the reason spin_locks.txt should be
updated, as others are having the same problems....

Anybody have answers/updates to Linus's concerns about "pretty old and
bogus language"?

