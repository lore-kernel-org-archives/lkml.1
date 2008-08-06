Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYHFRfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYHFRfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYHFRe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:34:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:64297 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYHFRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TPI9fOWighf8XtyEXEWNPXozBnHQROG/eaUFAzMxh5hNNG9BD1x9EGA2cLfKxNFP5k
         8IN4iYUTKxtbTH3vXAIxDdEKkoiaNXXK2w7JAQFSNXL941mTEHJdk5ygNft8AaCelM6l
         SyVfcmQzHvjIuWW++C5lmI2ytPgW9yX87lNMk=
Message-ID: <8bd0f97a0808061034je6d1fc8gdbc6b4bba9ddf89@mail.gmail.com>
Date: Wed, 6 Aug 2008 13:34:56 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Bryan Wu" <cooloney@kernel.org>, "Julia Lawall" <julia@diku.dk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0808060552g65d61647o7df045afccae9b3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105836.GA2903@localhost.localdomain>
	 <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com>
	 <19f34abd0808060428m1c317531v4a58679c4051c0e9@mail.gmail.com>
	 <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
	 <19f34abd0808060552g65d61647o7df045afccae9b3a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 8:52 AM, Vegard Nossum wrote:
> On Wed, Aug 6, 2008 at 2:14 PM, Mike Frysinger wrote:
>>>>> The patch was generated using the Coccinelle semantic patch framework.
>>>>
>>>> spam ?
>>>
>>> Hm? I'm sorry, I don't understand what you mean by that. Do you think
>>> the credit is undeserved?
>>
>> *shrug* ... i dont see other patches with things like:
>> The patch was generated with git.
>> The patch was generated with eclipse.
>> The patch was generated with emacs.
>> etc...
>>
>> we dont generally list all of the tools in the log message that was
>> used in *creating* a patch since it doesnt really add any value when
>> looking back historically at changes.
>
> Hm. I agree that git/eclipse/emacs/etc. information is not very
> useful. However...
>
> For errors found with lockdep, we usually put either the lockdep
> output in the commit message or say that it was found with lockdep.
> Having this information in the log is useful because it also
> establishes a track record for the tool which was used to discover/fix
> the error.
>
> Arguably, the semantic patch itself should be present in the log as
> well. There are different practices here, but in this case, the patch
> was quite long, and has already been included in a pending commit. Now
> others may use the same semantic patch (or a variation of it) and
> possibly find more "bad" code (possibly introduced after the semantic
> patch was first applied!).

that's reasonable to include the actual source (semantic patch) that
triggered the resulting change.
-mike
