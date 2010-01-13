Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134Ab0AMRHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0AMRHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138Ab0AMRHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:07:55 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40790 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0AMRHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:07:53 -0500
Message-ID: <4B4DFD87.3000904@s5r6.in-berlin.de>
Date: Wed, 13 Jan 2010 18:06:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality
References: <4B4C297A.5090405@freemail.hu> <4B4C9ED9.60905@csr.com> <4B4CAA15.4030200@freemail.hu> <4B4DDFDB.2000408@s5r6.in-berlin.de> <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
>> When you write a changelog, keep your audience in mind:
>> 
>>   - Developers, distributors, advanced users want to learn what a new
>>     release brings.  (OK, this audience stops reading after the initial
>>     headline of a "make XYZ table constant" commit.  Which just means
>>     that all the rest of the changelog is fluff that can be omitted.)
>> 
>>   - Developers, maintainers etc. want to understand years later why the
>>     code is how it is.  (For them, a commit like that is sufficiently
>>     described by the headline as well.)
> 
> Not surprisingly, I don't agree about this one.  I recall a series of 
> patches that said something like "used a script to change down/up to 
> mutexes".  The script wasn't included,

This "used a script to change down/up to mutexes" surely was meant to
convey that the submitter performed a mass change on code that he is not
particularly familiar with or frequently works with himself, i.e. it was
a mostly mechanical change in contrast to how proposed changes are
usually developed.

Semaphore to mutex conversions are/have been not as trivial as for
example a marking of an ID table as const.  Hence those hints that this
was a mostly mechanical conversion (certainly with some checking
afterwards) usefully put the submission into perspective for reviewers.
This information may also be useful after commit, hence it is good for
the SCM's changelog.

The find-and-replace macro itself and the processor which ran that macro
during the development of such a sem2mutex change is entirely uninteresting.

> not all down/ups were changed to mutexes,

If that was unexplained, the it was probably an unintended result of the
mechanical conversion by someone who does not have a deeper personal
investment in the affected code, or simply missed something for whatever
reason.

If it was by mistake, inclusion of the find-and-replace script into the
patch posting *after the --- delimiter* might have increased the chance
that a patch reviewer becomes aware of a possible error source
(inadequate match patterns...).  So that could be useful during review
before commit, but not so much if the change is revisited some time
after commit.

> and in short there was no understandable trace of why the change 
> was made where it was.

Then that changelog was bad since it missed to document the "Why", which
is one of the most important parts of a changelog.

> Perhaps that is a pathological example, but it is 
> not necessarily obvious in advance what needs precise documentation and 
> what does not.

Granted, it is subjective.  The perfect changelog which is ideal for
every possible audience does not exist.
-- 
Stefan Richter
-=====-==-=- ---= -==-=
http://arcgraph.de/sr/
