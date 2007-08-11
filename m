Return-Path: <linux-kernel-owner+w=401wt.eu-S1765227AbXHKTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765227AbXHKTQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbXHKTQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 15:16:34 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37265 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbXHKTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 15:16:32 -0400
Message-ID: <46BE0A32.7030004@gmail.com>
Date: Sat, 11 Aug 2007 21:12:50 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       =?ISO-8859-15?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org> <46BC6DA9.1050903@s5r6.in-berlin.de> <20070810201235.GA4133@uranus.ravnborg.org> <46BCF458.7010300@gmail.com> <46BD57AA.4050405@s5r6.in-berlin.de>
In-Reply-To: <46BD57AA.4050405@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2007 08:31 AM, Stefan Richter wrote:

> Rene Herman wrote:
>> On 08/10/2007 10:12 PM, Sam Ravnborg wrote:
>>
>>>> What primary requirements does in-tree Linux kernel documentation have
>>>> to fulfill in general?
>>> Skipping the obvious ones such as correct, up-to-date etc.
>>> o Readable as-is
>>> o Grepable
>>> o buildable as structured documents or almost like a single book
>>> o Easy to replicate structure
>>> o Maintainable in any decent text-editor (emacs, vim, whatever)
> 
> Low entry barrier for patches from unsuspecting occasional contributors?

Indeed, and AsciiDoc seems to fit nicely; it's easy to work from example. 
Look at:

http://www.methods.co.nz/asciidoc/asciidoc.txt

which is the source for:

http://www.methods.co.nz/asciidoc/asciidoc.css-embedded.html

In fact, one of the more important things for lowering the entry barrier is 
providing contributors with infrastructure so that a contributor is free to 
concentrate more on the what than the how and as was already argued in this 
thread, when you start laying down structure and rules for Documentation/, 
you end up with something close to AsciiDoc anyway.

>> Easy to put online?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=Documentation
> http://lxr.linux.no/source/Documentation/
> http://users.sosdg.org/~qiyong/lxr/source/Documentation/
> http://www.linux-m32r.org/lxr/http/source/Documentation/
> http://lxr.free-electrons.com/source/Documentation/

Easy to put online in a nice way. Compare:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/kbuild/makefiles.txt;h=e08ef8759a0780caaa237a5a88ad8d921208af98;hb=HEAD

and

http://www.ravnborg.org/kbuild/makefiles.html

as Sam posted. I certainly think the latter reads nicer (it's missing the 
table of content for now, but that appears to be a tool option).

> (I admit though that formats like asciidoc or docbook are beneficial for
> larger documentation files which want chapters, table of contents, and
> internal crossreferences.)

I personally wouldn't want to rudely outlaw plain text -- the discussion 
happened due to someone suggesting redoing some documentation in HTML. Some 
people suggested DocBook (hnnng!) and now asciidoc.

I think that DocBook is a bloody trainwreck (yes, "make pdfdocs" bombs out 
for me at the moment as well -- has it ever been different) but that some 
simple formatting quite often makes for an improvement over plain text.

HTML directly would do as far as I'm concerned, but AsciiDoc can also 
generate that and additionally imposes more structure (in the sense of 
uniformity) than direct HTML would. On the downside it still requires some 
external software, on the upside it directly translates to many more formats 
when viewed as a DocBook pre-processor.

Works for me...

Rene.
