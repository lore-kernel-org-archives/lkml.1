Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZB1XCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZB1XCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZB1XB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:01:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44845 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZB1XBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:01:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A9C252.50204@s5r6.in-berlin.de>
Date: Sun, 01 Mar 2009 00:01:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk>
In-Reply-To: <20090228210223.GA23191@sirena.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Sat, Feb 28, 2009 at 08:25:07PM +0100, Stefan Richter wrote:
>> It isn't just a non-obvious issue with git, it is *no issue* with git in
>> the first place.  It also is no issue with other patch importing tools
> 
> Well, exactly.  There is no issue within git so it's not obvious that
> people are going to have a problem when you're working in git.

Forget git.  It's also no problem if one is never ever working "in git".
 (No problems with tools anyway.)

I for one don't use git in patch creation, review, testing, submission,
and publication of patches (except for feeds to Linus and -next).

>> Since "Subject = title = beginning of changelog" is the long established
>> norm and since the other patch handling tools (and people who handle
>> patches) support this norm, checkpatch should follow this convention as
>> well and count a non-empty RFC 2822 Subject header as one non-empty
>> changelog line.
> 
> As I have previously said, that is not the case in reality.  There
> appears to be substantial sentiment among people handling patches that
> not having any text in the body of the e-mail makes it harder to handle
> patches.

It is indeed a problem
  - if the patch title alone insufficiently describes the patch
or
  - if a patch reviewer believes that it is OK to ignore patch titles.

Checkpatch cannot test for the former and should not test for the latter.

> I don't have that issue myself but I understand it and it
> seems easier to write longer changelogs than to try to change everyone's
> workflows.

So for these people your new checkpatch warning is valid.
For everybody else this warning is a false positive.

> Quite a few of the one line changelogs could probably
> benefit from being expanded a little anyway.

Granted.  But only people can detect this, a script can't.

BTW, a data point:

I just looked at firewire patches post 2.6.25 and found 32 patches out
of 272 patches which only had one line as changelog line (including the
title, excluding Signed-off-by).  I am still very satisfied with their
changelogs.  So that would be an unnecessary checkpatch warning in 12%
of patches which I dealt with in the past few months.

However, 9 of the patches with oneliner log were for a submitted
out-of-tree driver, i.e. cleanup related.  Since that cleanup is over
now, the percentage of easy to explain patches in my practice will go
down again.  Therefore I will shut up now even though I still disagree
with your way of counting changelog lines. :-)
-- 
Stefan Richter
-=====-==--= --== ----=
http://arcgraph.de/sr/
