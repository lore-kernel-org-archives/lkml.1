Return-Path: <linux-kernel-owner+w=401wt.eu-S935405AbZLPW3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935405AbZLPW3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935218AbZLPW3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:29:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:44459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbZLPW3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:29:00 -0500
Message-ID: <4B295ED1.3010607@kernel.org>
Date: Wed, 16 Dec 2009 14:27:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big	range
 for devices under it - v13
References: <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit!su.com> <4B0C69AD.3030106@kernel.org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D286.4020607@kernel.org> <20091216125458.42bf222e@jbarnes-piketon> <20091216211158.GF26757@ldl.fc.hp.com>
In-Reply-To: <20091216211158.GF26757@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hi Yinghai,
> 
> * Jesse Barnes <jbarnes@virtuousgeek.org>:
>>> -v13: change resource_list to resource_list_x, to save size and flags
>>> aside, otherwise grandchild res will get confused with son's res as
>>> could be used
> 
> One difficulty that I have in reviewing is the multiple patch
> revisions buried deep within a thread.
> 
> Blame my small brain for not being able to keep track of all
> the revision-as-mail-responses in one coherent body of work.
> 
>> Patches 4-6 make me the most nervous, since they have the potential of
>> really changing our resource allocation (hopefully for the better) on
>> many platforms.
>>
>> Linus, can you check them out and see if you're ok with the direction?
>>
>> Patches 7-9 seem like they've recieved some review from Alex and
>> Kenji-san, but I don't see acks or reviewed-bys on them.
>>
>> Alex and Kenji-san, are you ok with them assuming the previous patches
>> or something like them go upstream?
> 
> Can you please repost your next revision (after taking Jesse's
> review comments) in a new thread?
> 

can you check


git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git >> master

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/master

i rebased them to linus tree 12-12-2009.

Thanks

Yinghai
