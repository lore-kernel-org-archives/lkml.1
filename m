Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZJVK0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZJVK0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZJVK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:26:45 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46972 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZJVK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=BkPd1wenI6Pv06+TRuy8K23WTpNinE6FXbV+ISybtFjEBeaFI7MWqHiiQn4kR4w030
         22FyEjeDQsxISLaw9AaOaMEYPYaBySgcAQDhRF531ErVg/cr9P3goAxzAoER/50fkR4p
         jgI25sV2+LovrEKZX2a9mUhEtoAju5KMutImM=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <4ADF06B7.50508@zytor.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com>
	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
	 <20091016180631.GA31036@us.ibm.com>
	 <20091019174405.GE27627@count0.beaverton.ibm.com>
	 <4ADCDAA8.5080408@zytor.com>
	 <20091019235012.GF27627@count0.beaverton.ibm.com>
	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>
	 <4ADF06B7.50508@zytor.com>
Date: Thu, 22 Oct 2009 12:26:48 +0200
Message-ID: <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Wed, Oct 21, 2009 at 3:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
>>
>> My question here is: what does "3" actually mean? In general, system
>> calls have not followed any convention of numbering to indicate
>> successive versions -- clone2() being the one possible exception that
>> I know of.
>>
>
> "3" is number of arguments.

sys_clone3(struct clone_struct __user *ucs, pid_t __user *pids)

It appears to me that the number of arguments is 2.

> It's better than "extended" or something like
> that simply because "extended" just means "more than", and a number at least
> tells you *how much more than*.

I'm not sure why you think including a number in the name tells us
"how much more than". Unless you are considering the numbering to be
version numbers, which apparently is not what you mean.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
