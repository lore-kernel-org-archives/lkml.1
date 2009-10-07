Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZJGWAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZJGWAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZJGWAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:00:05 -0400
Received: from fifo99.com ([67.223.236.141]:56377 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZJGWAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:00:04 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Daniel Walker <dwalker@fifo99.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: rostedt@goodmis.org, Andy Whitcroft <apw@canonical.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <m3my42uc24.fsf@intrepid.localdomain>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop> <m33a5ww8kn.fsf@intrepid.localdomain>
	 <1254887534.18167.253.camel@desktop> <m3hbubv779.fsf@intrepid.localdomain>
	 <1254925617.18167.262.camel@desktop>
	 <1254928114.1696.164.camel@gandalf.stny.rr.com>
	 <1254929907.18167.301.camel@desktop>  <m3my42uc24.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 14:58:55 -0700
Message-Id: <1254952735.18167.350.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 23:30 +0200, Krzysztof Halasa wrote:
> Daniel Walker <dwalker@fifo99.com> writes:
> 
> > Just relax the submission rules so that checkpatch is basically an
> > optional part of the submission process. Adding that you don't actually
> > need to run it, you don't need a good reason not to follow the rules
> > etc.. Or expand on it to fully explain what you think the deal is or
> > should be.
> 
> Oh come on... The SubmittingPatches is a HOWTO-style document for people
> who want to get their patches merged. Obviously a common sense dictates
> you need a good reason to ignore this or that. "Looks better" and
> "I find it easier to work with" are good reasons since this is source
> code, for humans to work with.

The whole point of this black list is to allow people to give good
reasons why they don't follow the tool.. Once in the blacklist those
errors that are getting ignored become formally ignored.. So I haven't
been against people having a good reason not to fix the errors, but you
still need a good reason. I've checked 1000's of patches and Steven's
code is the only one that I've found which uniformly violates the coding
style ..

> BTW, the file says:
> 
> "Check your patches with the patch style checker prior to submission
> (scripts/checkpatch.pl).  The style checker should be viewed as
> a guide not as the final word.  If your code looks better with
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> a violation then its probably best left alone.

I think that exists since the tool can parse incorrectly sometimes and
flag things that it shouldn't be flagging (often times are checkpatch
defects).. For instance a large macro that only creates a function would
not need to be wrapped in a "do { } while(0);" .. So in those cases the
tool can't be the final word, this list (or a list) needs to be the
final word. Usually in those cases there is no need to explain the error
since it's clear what's happening in the code..

> The checker reports at three levels:
>  - ERROR: things that are very likely to be wrong
>                                ^^^^^^

Well, "very likely" is pretty strong wording for a this kind of tool ..

>  - WARNING: things requiring careful review
>  - CHECK: things requiring thought"
> 
> Only "very likely".
> 
> WRT tabs vs spaces, I wonder if using only spaces would be a better
> idea. Theoretically using tabs for syntactic indentation only is better,
> but the tools (editors) aren't up to the task yet.

You can usually change your editor to conform .. I know emacs usually
does spaces for tabs, but I'm sure you can change it's config to use
real tabs .. I don't use emacs tho.

Daniel

