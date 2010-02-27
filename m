Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968142Ab0B0JzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:55:05 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60396 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968104Ab0B0JzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VWikWCcqZOyqFWwU7sSn9IUF0NmWw2kGvGPuMNRG3Px1jJ/djHh3ZA++FKCk+ppG9J
         ljSV3gZ/HK+62iySy402+pgBxD/dnNMRbezW3zdG8fTBsCvz469s+cMUxYBcQdy2mAJt
         RXGNSz2MojuhGZxC74Hny40kSGUK+Tsnpmh84=
MIME-Version: 1.0
In-Reply-To: <1267194445.6328.111.camel@gandalf.stny.rr.com>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
	 <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
	 <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
	 <1267170179.12041.4.camel@Joe-Laptop.home>
	 <a8e1da1002260155l5e75a473oca5649ab33cce124@mail.gmail.com>
	 <1267194445.6328.111.camel@gandalf.stny.rr.com>
Date: Sat, 27 Feb 2010 17:55:00 +0800
Message-ID: <a8e1da1002270155u1d708399iaacbb5d354a14f40@mail.gmail.com>
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: rostedt@goodmis.org
Cc: Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-02-26 at 17:55 +0800, Dave Young wrote:
>
>> Spliting is necessary from my point of view.
>
>> with the patches applied:
>>
>> time:
>> real 15m16.504s
>> user 12m51.866s
>> sys 1m39.700s
>>
>> vmlinux .text size: 003bfcd2
>>
>> without the patches applied*
>> time:
>> real 15m20.518s
>> user 12m54.120s
>> sys 1m40.190s
>>
>> vmlinux .text size: 003bfcea
>
> Why the change in text size? If moving stuff around in headers affects
> the final result, I'm thinking that you did something wrong.

trace/printk/panic/string stuff just being moved to another head file,
then included
in kernel.h, so there shouldn't be difference with before.

So I guess it's the hexdump/int_sqrt head file which are removed from kernel.h?
>
> The merge for x86 did a lot of file manipulation, but Thomas and Ingo
> would always test that the binary result was the same. If the binary
> result is different, then something went wrong with the file
> manipulations.
>
> -- Steve
>
>
>
>



-- 
Regards
dave
