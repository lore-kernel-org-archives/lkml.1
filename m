Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbZLRWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbZLRWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZLRWDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:03:35 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:51749 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZLRWDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lqoavVu/xTL1oLi7UoZdiVP7l/OUMMzekD1MjAlTXWWe/1uT+Bc54Y1zPucy7MO0CT
         ekmBjB3Hq+44MSGuvFjGrqPO8aEz69lWOCdbHhRuXx38yr3JxKs00hk7KplCa1qQQ1UC
         x/DStFQieEmh/RwVcLq7U1fhiLqeF2W5pZmMw=
MIME-Version: 1.0
In-Reply-To: <20091219085640.c3414f51.sfr@canb.auug.org.au>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com> 
	<20091219085640.c3414f51.sfr@canb.auug.org.au>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 14:03:13 -0800
Message-ID: <43e72e890912181403k3a194326jbb8ca70a16cdcb74@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 1:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Luis,
>
> On Fri, 18 Dec 2009 09:26:29 -0800 "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>>
>> I tend to always be on a 2.6.32 kernel + John's queued up patches for
>> wireless for the next kernel release (I use wireless-testing). My
>> system is a Thinkpad T61, userspace is Ubuntu 9.10 based (ships with
>> git 1.6.3.3) and I kept an ext3 filesystem to be able to go back in
>> time to 2.6.27 at will without issues.  I git clone'd linux-next a few
>> weeks ago. After a few days I then tried to git pull and my system
>> became completely unusable, It took *ages* to open up a terminal and
>
> The start of the daily linux-next boilerplate says:
>
>> If you are tracking the linux-next tree using git, you should not use
>> "git pull" to do so as that will try to merge the new linux-next release
>> with the old one.  You should use "git fetch" as mentioned in the FAQ on
>> the wiki (see below).
>
> (Unfortunately, the wiki seems to be unavailable at the moment)
>
> I am guessing that the merge that git is attempting is killing your
> laptop (though besides the number of common commits I am not sure why).
> Please try using "get fetch" instead.

Indeed, I learned my lesson now. Thanks for the details.

Now granted, even if 'git merge' is killing my laptop due to the
conflicts of the insane merge I was trying to do it *still* should not
make my box completely unresponsive for so long. And given that I'm
using mostly distribution specific kernel config options and my have
ruled out my hard drive it seems a general serious kernel issue even
down to 2.6.27. Whatever git is doing I'm sure other userspace
software can also end up generating and would make any user go
completely bananas. I was about to rip my hair out.

  Luis
