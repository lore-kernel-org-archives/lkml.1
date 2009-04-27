Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZD0WWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZD0WWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZD0WW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:22:27 -0400
Received: from cmpxchg.org ([85.214.51.133]:32981 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZD0WW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:22:27 -0400
Date: Tue, 28 Apr 2009 00:20:35 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jiri Kosina <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to properly post/disseminate kernel cleanup/janitorial possibilities?
Message-ID: <20090427222035.GA2700@cmpxchg.org>
References: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added Jiri on CC]

On Mon, Apr 27, 2009 at 04:46:46PM -0400, Robert P. J. Day wrote:
> 
>   since i, on an occasional basis, run a set of scanning scripts i
> wrote and promptly annoy the crap out of everyone with the results,
> i'm open to the proper way to do this scanning and get the results out
> there to people who might be interested while not bugging those folks
> who aren't.
> 
>   a while back, a few people suggested a wiki page, while others
> disagreed, suggesting that no one will follow a link to a wiki page
> and will only read what's directly on the list.  grapple, grapple.
> 
>   in the end (as i'm sure you're aware by now), i post the results
> here:
> 
>   http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup
> 
> i'm convinced that there's value in the links i've promoted lately --
> scanning Kconfig files for unused or "bad" CONFIG variables, not just
> to clean historical cruft out of those files but because, on occasion,
> the scanning really does track down typoes and errors.
> 
>   not quite so critical is a "style" script i wrote, which looks for
> places to simplify code by using some of the macros/functions defined
> in include/linux/kernel.h.  i ran that script again earlier today, and
> posted only *some* of the results here:
> 
>   http://www.crashcourse.ca/wiki/index.php/The_style_script
> 
> long story short, i have a *pile* of scripts and sub-scripts i'm happy
> to run and post the results of since it takes practically zero time on
> my part, i'm just open to what folks think is the most productive way
> to do that, and also for any other scanning i can add since, by now,
> any other patterns to scan for would just represent adding a line or
> two to a script.
> 
>  thoughts?

Yes.  I wonder why you take the time to generate the output and email
it but then stop there instead of just sending patches?

grep -A5 TRIVIAL MAINTAINERS

Perhaps Jiri can pick up some of the patches that remove stale config
symbols, correct typos etc.

Yes, these corrections take care of cruft.  But I think installing
output of scripts on wiki pages and asking for other people to fix
them up is more than these things deserve.  It's a bit like writing a
list containing

	- wash up mug
	- grind beans
	- boil water
	- put grinded beans in mug
	- put filter in mug
	- put hot water in mug

instead of just making coffee already.

	Hannes
