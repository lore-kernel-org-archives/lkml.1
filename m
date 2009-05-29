Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbZE2NPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbZE2NPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759371AbZE2NPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:15:31 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34834 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263AbZE2NPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=I+peG3Hx6BZH2E1YUFFgLh/TD7jZz8lcvMMlOJI3paHdZ1tBLARWS3Z3izPtlDPci0
         tjuM/LG4kQ34VONWbAa0SONT7soZUIdk9FwXlk0rLbLpe8BhO0b70UZZXec1JTk0qGQ+
         qRP0BwYd9rMQumjm0qevKofP1166LS6OUuxEU=
MIME-Version: 1.0
In-Reply-To: <b0b0b0000905290611r45b1d528o98ee26ec0f534639@mail.gmail.com>
References: <b0b0b0000905290551t7e0a081bm814de19a8101814a@mail.gmail.com>
	 <20090529135749.3531240f@lxorguk.ukuu.org.uk>
	 <b0b0b0000905290611r45b1d528o98ee26ec0f534639@mail.gmail.com>
Date: Fri, 29 May 2009 16:15:30 +0300
Message-ID: <b0b0b0000905290615j1a4c1f97q1452bd74d04ec66b@mail.gmail.com>
Subject: Fwd: per user memory limit and LSM module
From: Iliya <vnsavage@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Iliya <vnsavage@gmail.com>
Date: Fri, May 29, 2009 at 4:11 PM
Subject: Re: per user memory limit and LSM module
To: Alan Cox <alan@lxorguk.ukuu.org.uk>


On Fri, May 29, 2009 at 3:57 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Any suggestions on how can I quickly get or maintain a list of all the
>> running tasks per user(or just the memory usage), without patching the
>> kernel would be greatly appreciated.
>
> Even if you could what would you do with it, large parts of memory don't
> have a single owner and even if they did you would have to traverse tens
> of thousands of objects so it would be incredibly slow.
Thank you for your reply.
If I can quickly sum, let's say the tsk->mm->total_vm (although this
would not count the overcommiting) for all tasks owned by a user, I
can limit that.
What I really need is to make sure that none of the users would eat
all the memory or get the system in OOM state.
>
> Take a look at the containers work and OpenVZ as I suspect that is what
> you need to work from.
The containers will probably do the job but the module is
multi-purpose and I would rather have everything at one place if
possible..
>
