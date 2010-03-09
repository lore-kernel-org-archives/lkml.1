Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0CIRBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:01:41 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45677 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0CIRBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LsUbYn8na6lWPTMtEXk5LkKqUzwJcsl6xrbfnapL1sCpeD5LmPPXFIIKOtmucwVjmS
         dmZZGkvdRJ5LjtuuVNi74Y4C6SASitPOKWU4eQ75YivRXa2uyZwhFtjWmjYd3wMH7rwQ
         sBstG9LiwIUNCfVwNqaCPow5tVtEqL683XUJk=
MIME-Version: 1.0
In-Reply-To: <4B967AEE.2060905@intcomgrp.com>
References: <elUoX-6na-35@gated-at.bofh.it> <4B967AEE.2060905@intcomgrp.com>
Date: Tue, 9 Mar 2010 14:01:36 -0300
Message-ID: <f5ca57691003090901r399b1e78yb66c8ef4fe15440b@mail.gmail.com>
Subject: Re: [PATCH] Security: key: keyring: fix some code style issues
From: Chihau Chau <chihau@gmail.com>
To: James Kosin <jkosin@intcomgrp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You said me that it may introduce a serious BUG later so I have undone
this change.

Regards.

2010/3/9 James Kosin <jkosin@intcomgrp.com>:
> On 3/8/2010 6:20 PM, Chihau Chau wrote:
>> From: Chihau Chau <chihau@gmail.com>
>>
>> This fixes to include <linux/uaccess.h> instead <asm/uaccess.h> and some
>> code style issues like to put a else sentence below close brace '}' and
>> to replace a tab instead of some space characters.
>>
>> Signed-off-by: Chihau Chau <chihau@gmail.com>
>> ---
>>  security/keys/keyring.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
>> index e814d21..840be66 100644
>> --- a/security/keys/keyring.c
>> +++ b/security/keys/keyring.c
>> @@ -17,7 +17,7 @@
>>  #include <linux/seq_file.h>
>>  #include <linux/err.h>
>>  #include <keys/keyring-type.h>
>> -#include <asm/uaccess.h>
>> +#include <linux/uaccess.h>
>>  #include "internal.h"
>>
>>  /*
>> @@ -306,7 +306,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
>>       key_check(keyring);
>>
>>       /* top keyring must have search permission to begin the search */
>> -        err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
>> +     err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
>>       if (err < 0) {
>>               key_ref = ERR_PTR(err);
>>               goto error;
>> @@ -775,8 +775,7 @@ int __key_link(struct key *keyring, struct key *key)
>>               smp_wmb();
>>               klist->nkeys++;
>>               smp_wmb();
>> -     }
>> -     else {
>> +     } else {
>>               /* grow the key list */
>>               max = 4;
>>               if (klist)
>
> Chau,
>
> What happened to the other part of the patch to fix the "} else {" above
> where you had tried to remove the {} ?
>
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Chihau Chau
