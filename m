Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbXEYNix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbXEYNix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXEYNir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:38:47 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:37775 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXEYNiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:38:46 -0400
Subject: Re: [RFC] LZO de/compression support - take 4
From: Richard Purdie <richard@openedhand.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Andrey Panin <pazke@donpac.ru>, Bret Towe <magnade@gmail.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>
In-Reply-To: <a781481a0705250537o768c609evaf32d517444f7aca@mail.gmail.com>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <1180095000.5864.48.camel@localhost.localdomain>
	 <a781481a0705250537o768c609evaf32d517444f7aca@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 May 2007 14:38:24 +0100
Message-Id: <1180100304.5864.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 18:07 +0530, Satyam Sharma wrote:
> On 5/25/07, Richard Purdie <richard@openedhand.com> wrote:
> > On Fri, 2007-05-25 at 17:15 +0530, Nitin Gupta wrote:
> > > Richard, can you please provide perf. results for this patch also?
> > > Also, can you please mail back latest version of your LZO patch? In
> > > meantime, I will try to include benchmarking support to the
> > > 'compress-test' module.
> >
> > This version is 15% slower at decompression and about equal on
> > compression.
> 
> I hope you tested your _safe variant against this, Nitin has done away
> with the _unsafe version in this patch. 

I am.

> Also, are you using your crypto
> lzo-support + tcrypt changes ( http://lkml.org/lkml/2007/5/1/303 ) to
> benchmark these?

No, I'm putting the code into userspace and testing it there. Its not
difficult since there is little support needed from the kernel for
either set of code.

The tester runs each one in turn under the same circumstances from the
same binary and gives me a speed for each. Multiple runs return
consistent values and I'm being careful to make sure its an otherwise
idle machine and processes enough data to make sure there is no nasty
cache effects.

> > I am however still strongly of the opinion that we should just use the
> > version in -mm (which is my latest version).
> 
> Right, if the difference is anything >10%, code cleanup does lose
> its attractiveness.

Agreed, and I still have the security and maintainability concerns. Add
them all together and its more unattractive.

Cheers,

Richard

