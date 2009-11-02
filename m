Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbZKBS7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbZKBS7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbZKBS7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:59:50 -0500
Received: from ix.technologeek.org ([213.41.157.215]:38948 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932220AbZKBS7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:59:50 -0500
From: Julien BLACHE <jb@jblache.org>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
	<87zl75h2mh.fsf@sonic.technologeek.org>
	<alpine.OSX.1.10.0911021258270.464@caridad.icculuslan>
Date: Mon, 02 Nov 2009 19:59:53 +0100
In-Reply-To: <alpine.OSX.1.10.0911021258270.464@caridad.icculuslan> (Ryan
	C. Gordon's message of "Mon, 2 Nov 2009 13:18:41 -0500 (EST)")
Message-ID: <87d4407nx2.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ryan C. Gordon" <icculus@icculus.org> wrote:

Hi,

> "A lot" is hard to quantify. We can certainly see thousands of forum
> posts for help with software that hadn't been packaged yet.

"A lot" certainly doesn't mean "all of it", sure, but that's already a
clear improvement over the situation 10 years ago.

> I can't imagine most people are interested in building repositories and 
> telling their users how to add it to their package manager, period, but 
> even less so when you have to build different repositories for different 
> sets of users, and not know what to build for whatever is the next popular 
> distribution. For things like Gentoo, which for years didn't have a way to 
> extend portage, what was the solution?

You need to decide if and how you want to distribute your software,
define your target audience and work from there. Yes, it takes some
effort. Yes, it's not something that's very valued by today's
standards. So what?

You can as well decide that your software is so good that packagers from
everywhere will package it for you. Except sometimes your software
actually isn't that good and nobody gives a damn.

As it stands, it really looks like your main problem is that it's too
hard to distribute software for Linux, but you're really making it a lot
more difficult than it really is.

Basically, these days, if you can ship a generic RPM and a clean .deb,
you've got most of your users covered. Oh, that's per-architecture, so
with i386 and amd64, that makes 4 packages. And the accompanying source
packages, because that can't hurt.

Anyone that can't use those packages either knows how to build stuff on
her distro of choice or needs to upgrade.

> I'm hearing a lot of "a lot" ... what actually happens today is that you 
> depend on the kindness of strangers to package your software or you make a 
> bunch of incompatible packages for different distributions.

Err. Excuse me, but if you "depend on the kindness of strangers" it's
because you made that choice in the first place. There is nothing that
prevents you from producing packages yourself. You might even learn a
thing or ten in the process!

When software doesn't get packaged properly after some time, it's
usually because nobody knows about it or because it's not that good and
nobody bothered. As the author, you can fix both issues.

>> > closed-source software
>> 
>> Why do we even care?
>
> Maybe you don't care, but that doesn't mean no one cares.

The ones who care have the resources to produce proper packages. They
just don't do it.

> I am on Team Stallman. I'll take a crappy free software solution over a 
> high quality closed-source one, and strive to improve the free software 

I don't think FatELF improves anything at all in the Free Software
world.

[static builds distributed as tarballs]
> I think we can do better than that when we're outside of the package 
> managers, but it's a rant for another time.

Actually, no, you can't, because too many people out there writing
software don't have a clue about shared libraries. If you want things to
work everywhere, static is the way to go.

> Having read the multiarch wiki briefly, I'm pleased to see other people 
> find the current system "unwieldy," but it seems like FatELF "kludge" 
> solves several of the points in the "unresolved issues" section.

Err, the unresolved issues are all packaging issues, to which the
solutions have not been decided yet. I don't see what FatELF can fix
here.

Now, to put it in a nutshell, you are coming forward with a technical
solution to a problem that *isn't*:
 - "my software, Zorglub++ isn't packaged anywhere!"
   Did you package it? No? Why not? Besides, maybe nobody knows about
   it, maybe nobody needs it, maybe it's just crap. Whatever. Find out
   and act from there.

 - "proprietary Blahblah7 is not packaged!"
   Yeah, well, WeDoProprietaryStuff, Inc. decided not to package it
   for whatever reason. What about contacting them, finding out the
   reason and then working from there?

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
