Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZL2HYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZL2HYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 02:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZL2HYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 02:24:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42130 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZL2HYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 02:24:35 -0500
Message-ID: <4B39AEB2.5040809@cs.helsinki.fi>
Date: Tue, 29 Dec 2009 09:24:34 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Emese Revfy <re.emese@gmail.com>
CC: linux-kernel@vger.kernel.org, rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 3/4] Constify struct kset_uevent_ops for 	2.6.32-git-053fe57ac
 v2
References: <cover.1260663000.git.re.emese@gmail.com>	 <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com>
In-Reply-To: <4B355AEF.3060508@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emese Revfy kirjoitti:
> Pekka Enberg wrote:
>> On Mon, Dec 14, 2009 at 2:00 AM,  <re.emese@gmail.com> wrote:
>>> From: Emese Revfy <re.emese@gmail.com>
>>>
>>>
>>> Signed-off-by: Emese Revfy <re.emese@gmail.com>
>>> ---
>>>  mm/slub.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index 4996fc7..fb63aca 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
>>>        return 0;
>>>  }
>>>
>>> -static struct kset_uevent_ops slab_uevent_ops = {
>>> +static const struct kset_uevent_ops slab_uevent_ops = {
>>>        .filter = uevent_filter,
>>>  };
>>   CC      mm/slub.o
>> mm/slub.c: In function 'slab_sysfs_init':
>> mm/slub.c:4679: warning: passing argument 2 of 'kset_create_and_add'
>> discards qualifiers from pointer target type
>> include/linux/kobject.h:164: note: expected 'struct kset_uevent_ops *'
>> but argument is of type 'const struct kset_uevent_ops *'
>>
>> Hmm?
>>
> 
> I double checked both the declaration and definitions of the affected
> function/structure and they are consistently const here.
> Can you tell me what patch/tree combination you encountered this warning with?

2.6.33-rc2 with your patch.
