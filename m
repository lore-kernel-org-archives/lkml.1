Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZLZAhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZLZAhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZLZAhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:37:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59250 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbZLZAhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:37:46 -0500
Message-ID: <4B355AEF.3060508@gmail.com>
Date: Sat, 26 Dec 2009 01:38:07 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 3/4] Constify struct kset_uevent_ops for 	2.6.32-git-053fe57ac
 v2
References: <cover.1260663000.git.re.emese@gmail.com>	 <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com>
In-Reply-To: <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Mon, Dec 14, 2009 at 2:00 AM,  <re.emese@gmail.com> wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>>
>> Signed-off-by: Emese Revfy <re.emese@gmail.com>
>> ---
>>  mm/slub.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 4996fc7..fb63aca 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
>>        return 0;
>>  }
>>
>> -static struct kset_uevent_ops slab_uevent_ops = {
>> +static const struct kset_uevent_ops slab_uevent_ops = {
>>        .filter = uevent_filter,
>>  };
> 
>   CC      mm/slub.o
> mm/slub.c: In function 'slab_sysfs_init':
> mm/slub.c:4679: warning: passing argument 2 of 'kset_create_and_add'
> discards qualifiers from pointer target type
> include/linux/kobject.h:164: note: expected 'struct kset_uevent_ops *'
> but argument is of type 'const struct kset_uevent_ops *'
> 
> Hmm?
> 

I double checked both the declaration and definitions of the affected
function/structure and they are consistently const here.
Can you tell me what patch/tree combination you encountered this warning with?
Thanks, Emese
