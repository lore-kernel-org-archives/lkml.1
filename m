Return-Path: <linux-kernel-owner+w=401wt.eu-S1764723AbXHLHPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764723AbXHLHPz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 03:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbXHLHPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 03:15:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46028 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbXHLHPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 03:15:30 -0400
Date: Sat, 11 Aug 2007 15:55:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>,
       =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-Id: <20070811155525.3ff6a8f3.randy.dunlap@oracle.com>
In-Reply-To: <20070810201235.GA4133@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	<200708091508.20626.hjk@linutronix.de>
	<p73hcn8g25m.fsf@bingen.suse.de>
	<20070810074047.GC31307@uranus.ravnborg.org>
	<46BC6DA9.1050903@s5r6.in-berlin.de>
	<20070810201235.GA4133@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 22:12:35 +0200 Sam Ravnborg wrote:

> > 
> > What primary requirements does in-tree Linux kernel documentation have
> > to fulfill in general?
> 
> Skipping the obvious ones such as correct, up-to-date etc.
> o Readable as-is
> o Grepable
> o buildable as structured documents or almost like a single book
> o Easy to replicate structure
> o Maintainable in any decent text-editor (emacs, vim, whatever)
> 
> > I've got a hunch that the most suitable format for Linux kernel
> > documentation, after careful consideration of what we want from it and
> > how we author and maintain it, will turn out to be...
> > 
> > ...plaintext.
> Asciidoc is quite close to plaintext and it looks to me that the
> formatting possibilities are quite good.
> 
> I spend an hour experimenting a little with
> Documentation/kbuild/makefiles.txt.

Hi Sam,

Sorry for the late question (I've been away :).

Was your makefiles.txt conversion done totally by hand?
Could it be automated?

or maybe there is not enough volume to even worry about that.

Yes, evaluating asciidoc has been on my radar (todo list) for
some time now.


> Diff below shows quite a lot of changes but for the most
> this is removal of the indent tab.
> Most likely I could have tweaked asciidoc to accept this
> but wanted to use default config.
> 
> The resulting html page can be seen here:
> http://www.ravnborg.org/kbuild/makefiles.html
> 
> Produced using:
> asciidoc -a toc -a numbered makefiles.txt
> 
> I would say that the asciidoc formatted plaintext text
> are readable despite the simple markup.
> And someone coming later will have no problems to follow
> the original markup.
> 
> Btw. is is not a full conversion, I stopped after a few chapters.
> asciidoc should be able to produce the index automatically
> but I had no luck but then I did not try hard either.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
