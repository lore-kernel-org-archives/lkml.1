Return-Path: <linux-kernel-owner+w=401wt.eu-S1030990AbXD1VoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030990AbXD1VoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030970AbXD1VoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:44:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37131 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030990AbXD1VoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:44:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4633BFFC.6060601@s5r6.in-berlin.de>
Date: Sat, 28 Apr 2007 23:43:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: irks with bugzilla (was Re: Linux 2.6.21)
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk>
In-Reply-To: <20070428202701.GA30343@flint.arm.linux.org.uk>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Sat, Apr 28, 2007 at 09:53:20PM +0200, Adrian Bunk wrote:
>> We are already quite good at ignoring bug reports that come through 
>> linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
>> than 1600 open bugs because this tells how bad we are at handling bugs.
>> How many thousand bug reports have been ignored during the same time on 
>> linux-kernel?
> 
> However, look at this bug:
> 
>   http://bugme.osdl.org/show_bug.cgi?id=7760
> 
> It's outside my knowledge to be able to fix for various reasons:
[...]

http://bugzilla.kernel.org/faq.cgi says, although it doesn't make a lot
of sense:

	"Q. If a bug has an owner does that mean they are working on it?

	A. No. If it is not in the ASSIGNED state then no one is working
	on it. The owner defaults to the subsytem maintainer. However,
	anyone who wants to submit a patch or add more info to a bug can
	do so. If the bug is reassigned to someone then the owner field
	will reflect that change."

So the "owner" field is bogus per default.  It would be better if the
bugzilla admins used only meta-addresses instead of a person's address
for any automatically filled-in "owner" field, unless a person
specifically wants to assume this automatic owner role.

I for example am not automatic owner of IEEE 1394 bugs;
drivers_ieee1394@kernel-bugs.osdl.org is.  And I am watching this pseudo
owner.

So in fact, the "owner" field should be replaced by
  - a mail exploder for each component which can be watched by
    interested people,
  - an "assignee" field which is filled in when a bug is assigned to a
    person.

Now that I am at it, another quote from http://bugzilla.kernel.org/faq.cgi :

	"Q. What does a subsystem maintainer do?

	A. He or She will track new bugs and assign them to people or
	reject it for various reasons. They periodically check to make
	sure things are getting worked on and review fixes to make sure
	they are well written."

A maintainer in the project called linux kernel will almost never assign
bugs to people (besides to himself).  He could if he employed or
otherwise supervised people to assign bugs to.

This especially applies to so-called "subsystem maintainers in kernel
tracker", which are not what many people think "subsystem maintainers" are:

	"Q. Why are the subsystem maintainers in kernel tracker
	sometimes different than the person listed in the MAINTAINER
	file?

	A. The subsystem maintainers in kernel tracker are volunteers to
	help track bugs in an area they are interested in. Sometimes
	they are the same person as on kernel.org sometimes they are
	not. There are still some categories with no maintainers so more
	volunteers are needed."

Another quibble:  This FAQ I'm quoting can be reached from the cover
page of bugzilla.kernel.org, i.e. from http://bugzilla.kernel.org/.
However, none of the other web pages of this site link to
http://bugzilla.kernel.org/.  Same for the bugme-admin contact.

Because I find bugzilla.kernel.org quite useful for myself, I filed
these complaints of mine under
http://bugzilla.kernel.org/show_bug.cgi?id=8396
http://bugzilla.kernel.org/show_bug.cgi?id=8397
http://bugzilla.kernel.org/show_bug.cgi?id=8394
in hope that they are taken into consideration by those who maintain the
site.
-- 
Stefan Richter
-=====-=-=== -=-- ===--
http://arcgraph.de/sr/
