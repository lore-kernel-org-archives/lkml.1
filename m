Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXGFAa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXGFAa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbXGFAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:30:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42743 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347AbXGFAaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:30:13 -0400
In-Reply-To: <200707051730.25776.vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: 7eggert@gmx.de, Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nix <nix@esperi.org.uk>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF957A5E7F.B63DEC46-ON8825730F.0082A484-88257310.0002C205@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Thu, 5 Jul 2007 17:30:09 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M5_05202007|May 20, 2007) at
 07/05/2007 20:30:13,
	Serialize complete at 07/05/2007 20:30:13
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>i dont see how blaming autotools for other people's misuse is relevant

Here's how other people's misuse of the tool can be relevant to the choice 
of the tool: some tools are easier to use right than others.  Probably the 
easiest thing to use right is the system you designed and built yourself. 
I've considered distributing code with an Autotools-based build system 
before and determined quickly that I am not up to that challenge.  (The 
bigger part of the challenge isn't writing the original input files; it's 
debugging when a user says his build doesn't work).  But as far as I know, 
my hand-rolled build system is used correctly by me.

>> checks the width of integers on i386 for projects not caring about that 
and
>> fails to find installed libraries without telling how it was supposed 
to
>> find them or how to make it find that library.
>
>no idea what this rant is about.

The second part sounds like my number 1 complaint as a user of 
Autotools-based packages: 'configure' often can't find my libraries.  I 
know exactly where they are, and even what compiler and linker options are 
needed to use them, but it often takes a half hour of tracing 'configure' 
or generated make files to figure out how to force the build to understand 
the same thing.  And that's with lots of experience.  The first five times 
it was much more frustrating.

>> Configuring the build of an autotools program is harder than 
nescensary;
>> if it used a config file, you could easily save it somewhere while 
adding
>> comments on how and why you did *that* choice, and you could possibly
>> use a set of default configs which you'd just include.
>
>history shows this is a pita to maintain.  every package has its own 
build 
>system and configuration file ...

It's my understanding that autotools _does_ provide that ability (as 
stated, though I think "config file" may have been meant here as 
"config.make").  The config file is a shell script that contains a 
'configure' command with a pile of options on it, and as many comments as 
you want, to tailor the build to your requirements.

