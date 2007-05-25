Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbXEYU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbXEYU4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXEYU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:56:16 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:44738 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbXEYU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e1SSoZ7Fxnx/h0x4oQgBnHNfFmZ8Yuw7HsrclnWaA0VhAjP7Q4wjkEOx/xWX5XL+99nQsEAZAWn+kxFJt/7K/vVWRw4J8yeQJzLdMkb7BU4iX9ziBP4NC5ligrpwFdGVOZNTfVLGtyAqbUP13a451fkqWvPaTuLF3Cp6ynU4WE0=
Message-ID: <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com>
Date: Sat, 26 May 2007 02:26:11 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: double exclamation (!!) suckage in the kernel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070525204127.GK4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
	 <20070525204127.GK4095@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Sat, May 26, 2007 at 01:53:59AM +0530, Satyam Sharma wrote:
> > Hello,
> >
> > Grepping through the sources I found 500+ occurrences of double
> > exclamation marks before identifier names (such as !!x -- I took care
> > to ignore occurrences of !! inside comment blocks, because there
> > are plenty of that sort too).
> >
> > !! are to be found even in the definitions of common macros such as
> > likely() and unlikely(), which hundreds of eyes must have seen over
> > the last year or so ...
> >
> > Are all these occurrences merely the debris of
> > s/something/!notsomething/g kind of patches or is there some
> > dark, unknown C / gcc wizardry I have absolutely no clue of?
>
> That's a question for a quiz in introductory course on C:

Ugh ... ok, I've embarrassed myself publicly already, so I'll
also be brave enough to take a C quiz here :-)

>         what type should x have for !!x to be a valid expression?

Any integer type (includes pointers)

>         what will be the type of result?

int (I guess boolean for C99?)

>         what are the possible values of the result?

{0, 1}

>         describe which values of x correspond to each possible value of !!x

Russell's mail has already answered that ...

> You have 10 minutes (and that's a fairly generous, actually).

Hmmm, looking through the grep output, actually, it seems some of the
occurrences of !! are indeed debris, but yes, most are actually a way to
force the output to {0, 1} when dealing with individual bits in code.

Satyam
