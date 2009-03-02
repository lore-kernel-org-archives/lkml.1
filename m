Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZCBPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZCBPRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZCBPRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:17:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54039 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZCBPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:17:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49ABF825.1010501@s5r6.in-berlin.de>
Date: Mon, 02 Mar 2009 16:15:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Theodore Tso <tytso@mit.edu>, Andy Whitcroft <apw@canonical.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
References: <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk>
In-Reply-To: <20090302131514.GC19744@sirena.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Sat, Feb 28, 2009 at 09:53:57PM -0500, Theodore Tso wrote:
>> Who's been complaining?  I can certainly tell you I'll complain in the
>> opposite direction, but that's because it actually causes me more work
> 
> Andrew Morton is one of them but not the only one.  Like I say, I don't
> want to claim that my changelogs are always ideal here, it was mostly
> the specific language used that made me think of doing this.

As far as I have observed, akpm's (Cc'd now) complaints are about
patches whose impact or benefit etc. are insufficiently explained ---
which is an issue on a higher level than pure formalism.  I believe I
too have seen the term "unchangelogged" (as you mentioned) in one of
those discussions but I associated lack of information with it rather
than a violation of a formalism.

I still say there are some straightforward changes which /can/ be well
explained in a single line (which would be the title line).  Still, by
far the most changes, including several kinds of janitorial changes,
require more explanation than that.  At which level a changelog should
start and how deep it should go is a rather subjective matter of course.
It is not trivial to give general advice on that, and it is impossible
to encode even simple tests for the quality of a changelog in a script
like checkpatch.

I for one am training how to write changelogs by the following methods:
 0. I occasionally write some of course.
 1. I intensively work with code written by other people long ago and
    wonder why it came to be how it is.  I look up when the code was
    added or changed and try to make sense of the changelogs which were
    provided at that time.
 2. I write release notes for a subsystem (targeted primarily towards
    users, secondarily towards developers) and use changelogs as primary
    input for that.
 3. I issue pull requests for new changes to be merged into the
    mainline.  These pull requests include a shortlog, plus extra
    information if the shortlog is unable to give a good picture of
    what the pull request is about.  The ideal would be that the
    shortlog says it all.
Nr. 1 especially trains to avoid lack of detail.  Nr. 2 and 3 train to
not forget the high-level viewpoint and to aim for clear language.  (I
am not sure about the success of this training though. ;-)
-- 
Stefan Richter
-=====-==--= --== ---=-
http://arcgraph.de/sr/
