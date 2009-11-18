Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZKRJhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZKRJhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZKRJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:37:39 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:48410 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZKRJhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:37:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u7UHjFHcy/MoLpCdcf/6F0hbWcNtEJMJpyL6BStfe8VTs8mwUAgLn5ahzvc6raA3+F
         7vk926kSQiv1T2/0TS6FFiZmRXNu8paQ0HKkJP0IJGo6Z+L8PsPWUxvisyhfEV6tHdAl
         UwQJ1mWCrmnDnPU3QG0ByKpx9/F8yJZYVssKQ=
MIME-Version: 1.0
In-Reply-To: <2375c9f90911180122p19030ea2gc395030178eb706d@mail.gmail.com>
References: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
	 <2375c9f90911172317x781e22a9y56ecb8e682e8e061@mail.gmail.com>
	 <b741c2440911172341g2251707fj999482473ab97830@mail.gmail.com>
	 <2375c9f90911180035v45b3f732gfe898092583a667a@mail.gmail.com>
	 <b741c2440911180054u1e610829g3646ec65701818ab@mail.gmail.com>
	 <2375c9f90911180122p19030ea2gc395030178eb706d@mail.gmail.com>
Date: Wed, 18 Nov 2009 17:37:44 +0800
Message-ID: <b741c2440911180137w3833fce2oe5bab93a8803a95b@mail.gmail.com>
Subject: Re: [PATCH] vfs: does call expand_files when needed
From: Liu Aleaxander <aleaxander@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 5:22 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Nov 18, 2009 at 4:54 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:
>
> <snip>
>
>>
>>>it's trivial, not so much an improvement, IMO.
>> So, shouldn't we do the optimize when there is a way to do that?
>>
>> While, I don't think so. And BTW, it's not just a problem of
>> optimization, but also make it be more sense: JUST call expand when
>> need. I don't know why you are rejecting about this, especially it did
>> optimized one call path(as you said), and it doesn't make the code
>> uglier than before but making it be more sense, and, in fact, a kind
>> of more readable.
>
>
> I am not rejecting it, I said this is trivial, so accepting it or droping
> it both are OK for me.
>
> I don't think the orignal code is ugly,
I didn't say the old code is ugly either. ;)

>'< fdt->max_fds' is not checked for expand_files(), but for find_next_zero_bit().
According to the old code, it's true, but it can also be applied to
expand_files checking. And just like what I said, we did rarely need
expand the file table as usual; even though we need, one-time expand
will be enough for a long while as it doubles the original size. (Am I
right?).



-- 
regards
Liu Aleaxander
