Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab0BYPxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:53:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59828 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab0BYPxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:53:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XKByK52CqKM+pAGLUnwSHk2+d7ic3Fm28zxufFqZmfczZG0YE7dWlVXab3u/WQaVRS
         zfVZ0OpRw0MRNSqogCf1pbg1dj0ol0DBjvddS0fREp5IT8UxwAhPCcXO9aH+VB0RatDe
         kQHJ8yXtKBcWgivvG54iTjrql0CwBvWoYNn2o=
MIME-Version: 1.0
In-Reply-To: <20100224140158.4f4dba78.akpm@linux-foundation.org>
References: <cover.1266907495.git.andre.goddard@gmail.com> 
	<20100224140158.4f4dba78.akpm@linux-foundation.org>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Thu, 25 Feb 2010 12:52:45 -0300
Message-ID: <b8bf37781002250752r53c8cb9ao8b8d6d09a3e67817@mail.gmail.com>
Subject: Re: [PATCH 0/6] Fix file descriptor leak on user-space processes and 
	cleanup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E . Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew!

On Wed, Feb 24, 2010 at 7:01 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 23 Feb 2010 04:04:22 -0300 Andr__ Goddard Rosa <andre.goddard@gmail.com> wrote:
>
>> Fix a file descriptor leak on user-space processes and perform a cleanup,
>> reducing the code size:
>> text    data     bss     dec     hex filename
>> 9949      72      16   10037    2735 ipc/mqueue-BEFORE.o
>> 9885      72      16    9973    26f5 ipc/mqueue-AFTER.o
>>
>> Andr__ Goddard Rosa (6):
>>   mqueue: remove unneeded info->messages initialization
>>   mqueue: apply mathematics distributivity on mq_bytes calculation
>>   mqueue: simplify do_open() error handling
>>   mqueue: only set error codes if they are really necessary
>>   mqueue: fix typo "failues" -> "failures"
>>   mqueue: fix mq_open() file descriptor leak on user-space processes
>
> Fixing the leak is far more important than the other five patches, and
> we'll want to backport the leak fix into earlier kernels.  So the
> bugfix patch should have been the first in the series!

Sure, thank you for that, I'll consider your good advice.

> So I've reordered the patches in that fashion and shall tag "mqueue:
> fix mq_open() file descriptor leak on user-space processes" as needing
> -stable backporting.
>
> The patches apply and build OK with that reordering, but please do
> double-check it, thanks.
>

I have double checked and they look good; thanks for the follow-up
patch pleasing checkpatch.
:)

Do I need to send another patch adding the Acked-by's or is it done by
email system automatically?

Best regards,
André
