Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbXEYVEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbXEYVEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXEYVD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:03:59 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:52526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbXEYVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tjs0jhfkc1J7MWpuUqXr3yowFpFrIGyjg9uz7611JvxI03S751+M9C6y/HM67QXOG9vRwrWxheWSSzLzE2LsiKYl5H2iBr+5z7vvRG2+FvghoybgjLE91o/5QA3nvU3FxIa7JI8eUakD46rI5Xqgg4iXzAVQ6FOvOWLeDEmuEUI=
Message-ID: <a781481a0705251403s4d4bb918mcf735fceb8309e30@mail.gmail.com>
Date: Sat, 26 May 2007 02:33:51 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: double exclamation (!!) suckage in the kernel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
	 <20070525204127.GK4095@ftp.linux.org.uk>
	 <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 5/26/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> >
> > That's a question for a quiz in introductory course on C:
>
> Ugh ... ok, I've embarrassed myself publicly already, so I'll
> also be brave enough to take a C quiz here :-)

Hmmm, and now I seem to have flunked ...

> >         what type should x have for !!x to be a valid expression?
>
> Any integer type (includes pointers)

gcc doesn't seem to mind a ! on a float either (does it do an implicit
cast to int first?). Can't think of too many situations where one would
want to do a ! on a float, actually, in any case ...

> >         what will be the type of result?
>
> int (I guess boolean for C99?)
