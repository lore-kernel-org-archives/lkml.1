Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab0BYD1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:27:34 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59099 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab0BYD1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:27:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dYLLSTGu+cHjpiejDvFg88WIT2roV2LKxJQQ66XrqbVwe/jiRpTFqzOc6SjlHPM0l5
         vC7xAdr4jwdlVHiAkOBdLn3cHnhPTYLTOyvKp46xRhzuArGWeZmQLa77dAFNx6M3AKb1
         PK4LfUYQ8yJc7IIDhALi852oBRrunUW7uXMMM=
MIME-Version: 1.0
In-Reply-To: <20100224181646.bde9c183.akpm@linux-foundation.org>
References: <20100222141934.GA9030@darkstar>
	 <1266867811.10646.196.camel@Joe-Laptop.home>
	 <a8e1da1002241752u637f7debi2ff46f50ac5edcd8@mail.gmail.com>
	 <20100224181646.bde9c183.akpm@linux-foundation.org>
Date: Thu, 25 Feb 2010 11:27:29 +0800
Message-ID: <a8e1da1002241927n53287c0xeab50d6d6d623d99@mail.gmail.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 10:16 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 25 Feb 2010 09:52:49 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Tue, Feb 23, 2010 at 3:43 AM, Joe Perches <joe@perches.com> wrote:
>> > On Mon, 2010-02-22 at 22:19 +0800, Dave Young wrote:
>> >> hexdump stuff in kernel.h should be put into a standalone head file
>> >
>> > I think it'd be clearer to have logging functions
>> > in kernel.h split into a separate header or grouped
>> > a bit better in kernel.h.
>> >
>> > I would have kernel.h #include that header though
>> > rather than splitting out things like hexdump functions
>> > into a separate file requiring yet another #include in
>> > source files.
>>
>> Andrew, what do you think about this?
>
> Well.  Avoiding bisection-bustage is hardly a priority any more, but
> let's not break bisection this time if we can avoid it.

Thanks, see it.

>
>> Actually I hesitate to send this patch as well, too many recipients
>> needed from get_maintainer.pl.
>
> They'll live ;)
>



-- 
Regards
dave
