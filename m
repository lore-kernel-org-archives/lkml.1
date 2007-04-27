Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXD0JGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXD0JGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbXD0JGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:06:47 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:44131 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXD0JGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:06:45 -0400
Message-ID: <4631BCF8.1060102@s5r6.in-berlin.de>
Date: Fri, 27 Apr 2007 11:06:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Rene Herman <rene.herman@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <462C7D74.60003@gmail.com> <20070426194316.GY3468@stusta.de> <4631077A.4050000@gmail.com> <200704261824.26738.gene.heskett@gmail.com>
In-Reply-To: <200704261824.26738.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Thursday 26 April 2007, Rene Herman wrote:
>>On 04/26/2007 09:43 PM, Adrian Bunk wrote:
>>> What exactly is missing that the kernel Bugzilla doesn't already offer?
>>
>>Users?
> 
> That is the best answer of all, and I've stated my objections to that very 
> nearly worthless utility before.  And that is exactly why it doesn't 
> have "Users".  I have never, ever gone to bugzilla without killing well over 
> an hour convincing it that yes, I really want DO to enter a bug report, not 
> search for an old one.  Let me simply say that such and such doesn't work, 
> attach the dmesg (or whatever) snip to show how it failed, and get on with 
> it.
[...]

Of course it is polite (and more or less expected from reporters,
independently of whether bugzilla or a mailinglist or personal e-mail is
used for a report) to search for similar reports and join them.
However, it doesn't stop there --- a bugzilla entry into which a lot of
different bugs are entered (because the reporters mistook them for the
same or didn't realize they face a number of separate problems) becomes
hard to handle for maintainers/ developers.

So, it is actually easier after all to have users create *duplicate*
bugs and then simply mark them as such once identified.  Bugzilla
directly supports tracking of duplicates while my mail user agent
doesn't.  (Some advanced MUAs might do, by tagging or the like.  But
that would only be visible to myself.)

As subsystem maintainer, I am actively using kernel.org's bugzilla and I
am polling more or less (mostly: /less/) frequently some distributor
bugzillas.  Here are my experiences:

  - I can't work without kernel.org's bugzilla simply because the
    average bug fixing rate of "my" subsystem is so slow.  I personally
    need a tracker better than some yellow sticky notes or whatever, and
    I chose kernel.org's bugzilla for it.

    That's one reason why I once and again ask people who report bugs at
    the -devel or -user mailinglist to enter their bug into bugzilla.
    But often I request this only after an initial conversation with the
    reporter, i.e. after the issue was already clarified a bit.  Side
    effects are that the effort of the user to enter the report becomes
    minimal (or even zero if I do it myself instead), and that the new
    entry is already rather qualified.

    Actually, a good deal of "my" currently unresolved bugs at
    bugzilla.kernel.org were entered by myself.  Some of those bugs are
    behind-the-scene bugs though which only indirectly affect endusers,
    thus wouldn't have reported by them anyway.

  - Using distributor's bugzillas is a mixed bag.  By nature, it takes
    more effort for kernel maintainers because linux-kernel is only one
    among a huge number of programs tracked in these bugzillas.

    There were times were I was able to get a lot of highly useful
    reports out of one particular bugzilla; and I name it here because
    its admins and users did such a great job IME: Redhat's bugzilla.
    Many of the bug entries there were highly focused and qualified and
    up-to-date, and some helped to get to bugfixes soon.  This positive
    experience somewhat diminished lately after the more prominent bugs
    were fixed.

    At other distributor bugzillas, the usually encountered difficulties
    besides the broad scope of their trackers were, in no particular
    order:
        - Lack of detail in bug descriptions,
        - many loosely related or unrelated bugs under the same ticket,
        - difficulties to work with the reporters to get more
          diagnostics (for varying reasons),
        - long delay between upstream release of regressions and
          report of regressions by distribution users,
        - my lacking polling frequency, being caused by and at the same
          time amplifying these other difficulties.

So, bugzilla.kernel.org and to a certain degree distributors' bugzillas
are valuable to me.  Still, switching between bugzilla and mailinglist
sometimes becomes awkward, IME in a similar way like switching between
mailinglist and personal e-mail.  Also, "my" subsystem (ieee1394) almost
doesn't have to deal anymore with new development, neither on the kernel
side nor as far as available hardware is concerned.  Therefore my
findings certainly do not reflect what other subsystem maintainers are
facing.

Back to MODULE_MAINTAINER and what Adrian said about where to report bugs:

>From the maintainer's point of view, my personal preference for bug
reports about "my" subsystem is, in descending order:
  - The -devel or -user mailinglist (but often in combination with
    bugzilla),
  - bugzilla,
  - ...?,
  - personal e-mail. (Just don't do it.)
But I do understand why the opener of this thread preferred personal
e-mail; he has explained it multiple times now.  He has valid points,
although they don't apply to by far most of the kernel subsystems.
-- 
Stefan Richter
-=====-=-=== -=-- ==-==
http://arcgraph.de/sr/
