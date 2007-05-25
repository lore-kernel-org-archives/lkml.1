Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbXEYUdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbXEYUdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbXEYUdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:33:00 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:20176 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbXEYUc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=umKWk8ScoeqWgKp0qe3NcA5+TOF//8HvS5RXgAF6mJV7gkYO//UdQbkwVbA7B1Mrx+CTTD7ZMFQsTh6uJph/bQAb8WFMAjH4YljCw65CV8tpXjdVhS9eB9fP6u7JlOiVoB1D6/WDrsy0vuT32BI1WpBTCPjI27uOdg/V3djHwEc=
Message-ID: <a781481a0705251332q6a3d4e24xefe999ebfdd437bc@mail.gmail.com>
Date: Sat, 26 May 2007 02:02:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: double exclamation (!!) suckage in the kernel
In-Reply-To: <20070525202854.GA24801@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
	 <20070525202854.GA24801@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Sat, May 26, 2007 at 01:53:59AM +0530, Satyam Sharma wrote:
> > Are all these occurrences merely the debris of
> > s/something/!notsomething/g kind of patches or is there some
> > dark, unknown C / gcc wizardry I have absolutely no clue of?
>
> Try building and running this:
>
> #include <stdio.h>
> int main()
> {
>         int i;
>         for (i = 0; i < 10; i++)
>                 printf("%d: %d\n", i, !!i);
>         return 0;
> }
>
> and you should see it's effect.

Ah, yes, of course I see now!

Thanks!
