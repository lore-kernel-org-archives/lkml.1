Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZBDSPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZBDSPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZBDSPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:15:15 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:55381 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZBDSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q1G9B52KBl64jy8jJntI1azU5XACLDFAFHkGxEKCbJkEJ2+cDAfwkR7QoC4AzDQS4m
         T+NmvCKwQXoQWwgjjxiqguqRoBmbz+V175Txk+i3aGUFedPvViWUzZglke2zSIoZlSAr
         aJ3Oqo6ui9LjsztRXikhXpEWDs8Z+g8R7nANI=
MIME-Version: 1.0
In-Reply-To: <20090204164623.GE25996@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.nXG.evYiJB@chimera>
	 <dd18b0c30902040723m70f87f7fp4af32702410036d7@mail.gmail.com>
	 <20090204164623.GE25996@elte.hu>
Date: Wed, 4 Feb 2009 18:15:10 +0000
Message-ID: <dd18b0c30902041015m2213d94cx72d41bd225afa3e9@mail.gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
From: Justin Mattock <justinmattock@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Justin Madru <jdm64@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 4:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Justin Mattock <justinmattock@gmail.com> wrote:
>
>> On Wed, Feb 4, 2009 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.28.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12505
>> > Subject         : 2.6.29-rc1 Firefox crashing on page load
>> > Submitter       : Justin Madru <jdm64@gawab.com>
>> > Date            : 2009-01-16 20:56 (20 days old)
>> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
>> > References      : http://marc.info/?l=linux-kernel&m=123213941914274&w=4
>> > Handled-By      : Justin P. Mattock <justinmattock@gmail.com>
>> >
>> >
>> >
>>
>> Well the hardest for this, was to reproduce
>> the error.(never did). I guess it can be taken
>> of if there was a patch for the fix, and the patch
>> made it into the main tree. but if this  is a firefox
>> issue, then a report needs to be filed with them.
>> so overall my answer is "I don't know."
>> :^)
>
> the error is spurious because gcc randomly stomps on user register state so
> the effects can be rather random and unpredictable.
>
> The fix:
>
>  552b8aa: Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
>
> was included in -rc2 already, so please test latest -git whether you can see
> any such troubles.
>
>        Ingo
>

Sure I'll test it.
I'm just in the process of compiling libc.
which looks like I'll be here for a while.

-- 
Justin P. Mattock
