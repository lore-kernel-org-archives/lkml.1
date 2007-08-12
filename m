Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbXHLDGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbXHLDGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXHLDF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:05:57 -0400
Received: from xenotime.net ([66.160.160.81]:60012 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750866AbXHLDF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:05:56 -0400
Date: Sat, 11 Aug 2007 20:11:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>,
       =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-Id: <20070811201151.c25261cf.rdunlap@xenotime.net>
In-Reply-To: <20070810201235.GA4133@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	<200708091508.20626.hjk@linutronix.de>
	<p73hcn8g25m.fsf@bingen.suse.de>
	<20070810074047.GC31307@uranus.ravnborg.org>
	<46BC6DA9.1050903@s5r6.in-berlin.de>
	<20070810201235.GA4133@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

[resend, sorry about duplicates]

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
