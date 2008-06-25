Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYFYHIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYFYHIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYFYHIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:08:12 -0400
Received: from il.qumranet.com ([212.179.150.194]:41668 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYFYHIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:08:11 -0400
Message-ID: <4861EED9.2080503@qumranet.com>
Date: Wed, 25 Jun 2008 10:08:09 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 2.6.26-rc7
References: <48616182.9030902@qumranet.com> <alpine.LFD.1.10.0806241809530.17712@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806241809530.17712@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 25 Jun 2008, Avi Kivity wrote:
>   
>> Linus, please pull from the repo and branch at:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.26
>>
>> to receive kvm updates for 2.6.26-rc7.  The patches fix host oopses,
>> guest interrupt loss, and total kvm clock borkage.
>>     
>
> Avi, you _really_ need to start respecting the merge window.
>
> If you can't learn, I will have to just stop pulling from you. This is 
> simply too big for this late in the game.
>
> I pulled, but I'm simply not going to continue doing this dance. I don't 
> care much for virtualization, so I've let it slide, but you need to learn 
> that 
>
>   
>> 18 files changed, 358 insertions(+), 266 deletions(-)
>>     
>
> is simply not acceptable this late. 
>   

You're right, I guess I should have disabled kvm clock for 2.6.26 (which 
makes up the bulk of the changes) and re-enabled it for 2.6.27, but 
ended up not resisting the temptation.

-- 
error compiling committee.c: too many arguments to function

