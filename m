Return-Path: <linux-kernel-owner+w=401wt.eu-S938336AbXHJNw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938336AbXHJNw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763167AbXHJNwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:52:44 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48113 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759652AbXHJNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:52:43 -0400
Message-ID: <46BC6DA9.1050903@s5r6.in-berlin.de>
Date: Fri, 10 Aug 2007 15:52:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andi Kleen <andi@firstfloor.org>,
       =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org>
In-Reply-To: <20070810074047.GC31307@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Aug 09, 2007 at 05:26:13PM +0200, Andi Kleen wrote:
>> Also I would expect much more people will know how to write html versus
>> DocBook.
> 
> Documentation should be easy to access and readable in the source format.
> For this purpose asciidoc seems to do a good job.
> 
> It is btw. discussed at git ML if they should shift due to toolset being
> slow but that happens to be the docbook utilities. asciidoc seems to be fast enough.
> And it can produce both HTML and docbook so seems to cover all cases.

It's true that asciidoc sources are nice to read in a plaintext viewer,
while HTML is not.  However, regardless whether the documentation is
written in HTML or docbook or asciidoc, all contributors will be forced
to learn the respective format --- otherwise the documentation will
become syntactically incorrect very quickly.

So, let's recall the start of this thread.  Stephen Hemminger wrote:
| Since the network device documentation needs a rewrite, I was thinking
| of using [CENSORED] format instead of just plain text.

What primary requirements does the network device documentation have to
fulfill?

What primary requirements does in-tree Linux kernel documentation have
to fulfill in general?

(Note that git's documentation has as one of its first and foremost
requirements that man pages can be generated.  This requirement does not
exist for the bulk of Linux kernel documentation.)

I've got a hunch that the most suitable format for Linux kernel
documentation, after careful consideration of what we want from it and
how we author and maintain it, will turn out to be...


...plaintext.
-- 
Stefan Richter
-=====-=-=== =--- -=-=-
http://arcgraph.de/sr/
