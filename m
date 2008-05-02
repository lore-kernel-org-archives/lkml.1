Return-Path: <linux-kernel-owner+w=401wt.eu-S935184AbYEBRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184AbYEBRkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbYEBRkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:40:46 -0400
Received: from smtp.enter.net ([216.193.128.24]:2855 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759369AbYEBRkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:40:46 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: How to reduce the number of open kernel bugs
Date: Fri, 2 May 2008 13:40:42 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Parag Warudkar" <parag.warudkar@gmail.com>,
       "Adrian Bunk" <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com> <200805021229.47038.dhazelton@enter.net> <87od7ovcpj.fsf@basil.nowhere.org>
In-Reply-To: <87od7ovcpj.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021340.42508.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008 13:27:04 Andi Kleen wrote:
> Daniel Hazelton <dhazelton@enter.net> writes:
> >  If the hardware works
> > perfectly in every other OS
>
> It depends. There used to be the famous case (not longer true now) that
> older Linux allocated memory from the top of the memory down and other OS
> generally allocated it the from bottom to up and when some of your top
> memory was broken Linux would often hit problems where other OS did not.

True.

> Also there can be the case when some OS use hardware quite differently
> or different hardware features than other. Standard case for example
> used to be that there were a few platforms where the SMM code had 64bit
> bugs and of course you would only hit them when running a 64bit OS which
> was Linux.

Sadly things like this will continue as long as there is a single OS that has 
more than a 70% market share of the common desktop market.

> A modern OS is a very complicated system with tens of millions of code
> lines and you can't assume they all program the hardware in the same way.
>
> Simple truths are often wrong.

Yes, but if the hardware *ISN'T* broken, then claiming it is and closing out a 
bug is the wrong thing to do. The right thing to do would be to find out why 
the hardware isn't working correctly for the OS/driver combination in 
question and, if possible, fix the driver.

>  - and possibly even previous versions of Linux -
>
> Now that is a more interesting case. But regressions are always taken
> seriously by all maintainers I know.
>

Look to the bug-report posted (cleaned of evidence that would incriminate any 
single person) by (IIRC) Adrian. The guy says "It worked with X and works in 
Windows, but it now fails with message Z."

Maintainer says "Your hardware is broken", closes the bug and then goes on to 
say "If the hardware isn't broken, talk to the people in charge of A and B 
because my code isn't buggy."

That is idiotic and immature.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
