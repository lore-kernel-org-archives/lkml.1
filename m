Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbXEYVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbXEYVhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765614AbXEYVhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:37:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:15617 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbXEYVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SJaI81XGfN4qaCq1HrxaflwfuAJLD7up8lyWqfzu5c5DF+FLqf4WYrCdyqBllz3eIW8Akq+bV9jBzlIdzxMxi7LalCtyA9b4eK7+bWEgtd05fTINLsXzd3yge134nT+X4QNuR8tWobfXFBHpyfeIg9KqNA5T4KE2yIUnwlN2STQ=
Message-ID: <a781481a0705251437k725b5218oab40ebe66dd661a8@mail.gmail.com>
Date: Sat, 26 May 2007 03:07:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: double exclamation (!!) suckage in the kernel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070525213213.GM4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
	 <20070525204127.GK4095@ftp.linux.org.uk>
	 <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com>
	 <20070525213213.GM4095@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Sat, May 26, 2007 at 02:26:11AM +0530, Satyam Sharma wrote:
> > also be brave enough to take a C quiz here :-)
> >
> > >        what type should x have for !!x to be a valid expression?
> >
> > Any integer type (includes pointers)
>
> Er, no...  Pointers are not integer types *and* you can use ! on any
> scalar type (including floating ones, even though it's not particulary
> useful there).

Yeah, I noticed this (with a sample program) just after the quiz ...

> > >        what will be the type of result?
> >
> > int (I guess boolean for C99?)
>
> Actually, ! and comparisons still give int in C99 (and !x is defined as
> (x == 0) in all situations).

Hmm, thanks for explaining this.

Satyam
