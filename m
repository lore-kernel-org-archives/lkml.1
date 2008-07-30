Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbYG3SYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbYG3SYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYG3SYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:24:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYG3SX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:23:59 -0400
Message-ID: <4890B153.6050305@zytor.com>
Date: Wed, 30 Jul 2008 11:22:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu>
In-Reply-To: <20080730180411.GA7896@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> Hi x86 guys.
>>
>> It turned out to be easy to enable um to use arch/x86/include so here 
>> is a git pull.
> 
> hm, we have a _ton_ of changes to include files queued up already, so 
> this is rather inconvenient.

Git *should* be able to track those changes across a rename and even 
with a rename on one branch and changes on another; in my experience it 
works well for filename renames, but git doesn't understand directory 
renames at all, so new files do have to be moved to their new locations 
manually.

> I missed the discussion on this, what's the point of renaming all these 
> files?

I know there has been talk about this on and off for a long time (to get 
all the arch code into arch/).  I don't know if there are any mechanical 
reasons for it, on top of that.

	-hpa

