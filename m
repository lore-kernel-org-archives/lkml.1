Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXGMNVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXGMNVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXGMNV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:21:29 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55987 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXGMNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:21:28 -0400
Message-ID: <46977C36.8010403@gmail.com>
Date: Fri, 13 Jul 2007 15:20:54 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com>	 <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>	 <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>	 <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com> <4696FC43.3000201@goop.org>
In-Reply-To: <4696FC43.3000201@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2007 06:14 AM, Jeremy Fitzhardinge wrote:

> Jesper Juhl wrote:

>> Yes and no.  If that will get things moving in the direction of
>> getting rid of the stack size as a config option, then I'm all for it.
>> But on the other hand it is my personal opinion that this is an area
>> where we should just make up our minds as to whether we want 4K or 8K
>> stacks and whether we want interrupt stacks or not, and then not have
>> it configurable at all.  
> 
> Well, smaller stacks are better where possible, but there's nothing 
> magic about 4k.

Except offcourse it happens to also be the value of PAGE_SIZE at least on x86...

> Sure, its mostly enough, but there's no particular reason to believe it
> will be enough for everything.  You could state a priori that all kernel
> code paths must fit into 4k of stack, but that's pretty arbitrary.

As far as I'm aware, the actual reason for 4K stacks is that after the 
system has been up and running for some time getting "1 physically 
contiguous pages" becomes significantly easier than 2 which wouldn't be 
arbitrary.

Rene
