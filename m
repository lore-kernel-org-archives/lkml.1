Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYKRH5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYKRH5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYKRHw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:52:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYKRHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:52:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=g6kjS3c4dlEbWwgyenB+JEPC+p9HJe3RbEdh7ZECxeS3QmwCURGtoEwI5NsGCZhsm
	2h+qmRrqwVewRhzpi7PIQ==
MIME-Version: 1.0
In-Reply-To: <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
References: <20081115011452.GA28135@google.com> <49218FB4.6090805@nortel.com>
	 <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
Date: Mon, 17 Nov 2008 23:52:50 -0800
Message-ID: <b040c32a0811172352n537ef2e1h9628a97fbb838292@mail.gmail.com>
Subject: Re: busted CFS group load balancer?
From: Ken Chen <kenchen@google.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 7:37 AM, Chris Friesen wrote:
>> It appears that the fair-group load balancer in 2.6.27 does not work
>> properly.
>
> There was an issue fixed post 2.6.27 where the load balancer didn't work
> properly if there was one task per group per cpu.  You might try
> backporting commit 38736f4 and see if that helps.

On Mon, Nov 17, 2008 at 12:04 PM, Ken Chen wrote:
> Tested git commit 38736f4, it doesn't fix the problem I'm seeing.

I would also like to mention that commit 38736f4 has stability
problems.  I put a kernel with this commit on several test machines,
and several of them had hard lockups within 2 hours of testing.  I
wasn't doing anything fancy.  The workload was pure 'while (1)' loop.
Though there are other background services running on those machines.

- Ken
