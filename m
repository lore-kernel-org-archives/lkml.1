Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXGMUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXGMUy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXGMUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:54:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:29024 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbXGMUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CfWFNrlKrNm2J552Raer/Li17E1B5S3SC5gKf3ROIePMr1k6ImC+dWYQKeaKtXdKUnLhT7N7QW82no2pup0y105Bn3Z5e+4X8s2RZVa+kI5oxoKXZp2J3+D60Wfnr9S0pyr44tzQUNll8Gwo+Y8ixwA4Sg4hQeBvTZia4ZOgoaE=
Message-ID: <9a8748490707131354y37793f0ag2c01b2bdf968f8cc@mail.gmail.com>
Date: Fri, 13 Jul 2007 22:54:47 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "TripleX Chung" <triplex@zh-kernel.org>
Subject: Re: Ask for help, about the trivial patches.
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4697C980.1040902@zh-kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4697C980.1040902@zh-kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Note: my explanations below are based on how I understand these
things, but I'm not the trivial patch monkey nor did I help create
these guidelines, so I'm in no way authoritative on the subject.

On 13/07/07, TripleX Chung <triplex@zh-kernel.org> wrote:
> I am working on the chinese translated version of
> Documentation/SubmittingPatches and get some problem about the "Trivial
> patches".I can not understand what "Trivial patches" exactly means.The
> documentation said:
>

If you are unclear of the meaning of the word "trivial", then take a
look here for an explanation: http://www.m-w.com/dictionary/trivial

> Trivial patches must qualify for one of the following rules:
>
>  Spelling fixes in documentation
>  //Understand
>
>  Spelling fixes which could break grep(1)
>  //Is there any wrong spelling won't break grep(1)?
>
Hmm, trying to think of examples and all I can think of is stuff like
"its" & "it's" - quite different meaning, very similar spelling.
Someone else can probably think of a better example...


>  Warning fixes (cluttering with useless warnings is bad)
>  //Understand
>
>  Compilation fixes (only if they are actually correct)
>  //Understand
>
>  Runtime fixes (only if they actually fix things)
>  //What kind of runtime fixes? Could anyone give some examples?
>
A simple and obviously correct fix for a memory leak.
A simple and obviously correct fix for a NULL pointer dereference.
A simple and obviously correct fix for a off by one error in a loop.
A simple and obviously correct fix for a buffer overrun.

Stuff like that.


>  Removing use of deprecated functions/macros (eg. check_region)
>  //Understand
>
>  Contact detail and documentation fixes
>  //Means Contact detail fixes and documentation fixes, right?

That's how I have always read it.

>    Are all the documentation fixes "trivial"?
>
No. Something like fixing a misspelled word, correcting
capitalization, adding a description of something that's currently
missing a description (assuming the description if correct), removing
trailing whitespace, and similar things would be trivial.
When you start changing the meaning of documentation then it needs to
be verified that what you write is actually correct, that is then no
longer a trivial change.


>  Non-portable code replaced by portable code (even in arch-specific,
>  since people copy, as long as it's trivial)
>  //Do not understand the words in the brackets.
>
It means that it's OK to replace non-portable code by portable code
even in architecture specific parts of the kernel, since people tend
to copy code from one architecture to another, so having even
arch-specific code portable is good since that means it will probably
still work when someone copies it to a different architecture. The
changes you make to the code to make it portable still have to be
trivial in nature though.


>  Any fix by the author/maintainer of the file (ie. patch monkey
>  in re-transmission mode)
>  //It means if I am the author of a file, when I modify the file, the
> patch is trivial, right?
>
Right. Maintainers are trusted to know what they are doing with the
code they maintain (and authors as well), so when the author or
maintainer of a piece of code submits a patch to the trivial patch
monkey, then it's accepted as OK.


> Please give me some advice. Thanks in advance.
>
I hope the above make things a little clearer. :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
