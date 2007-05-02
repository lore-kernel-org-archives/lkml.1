Return-Path: <linux-kernel-owner+w=401wt.eu-S1766852AbXEBTyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766852AbXEBTyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766856AbXEBTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:54:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766852AbXEBTyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:54:45 -0400
Message-ID: <4638EC24.2020703@redhat.com>
Date: Wed, 02 May 2007 15:53:08 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] New firewire stack
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de>
In-Reply-To: <20070502122147.GA31215@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Tue, May 01, Kristian Høgsberg wrote:
> 
>>   drivers/firewire/Kconfig          |   60 ++
> 
> NACK.
> Upgrade the current drivers/ieee1394/ with the new code, and keep all
> existing module names.

What's your reasoning here?  Having different module names allows people to 
compile both stacks and switch between them as they wish.

Another point in favour of different module names is that the new stack 
doesn't actually provide the same user space interfaces as the old stack. 
Basically, no applications use the raw kernel interfaces and the new stack is 
only compatible at the library level.  In the light of this, I think it's fair 
to change the module names.

As for putting the new stack in drivers/ieee1394 - I don't know, I think it 
makes sense to keep the new stack in it's own directory.  If it's a deal 
breaker for inclusion, let's talk about moving it, but it would be nice if you 
could elaborate just a little bit beyond "NACK".

thanks,
Kristian


