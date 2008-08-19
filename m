Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYHSLJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYHSLJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYHSLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:08:58 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:54565 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYHSLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MHP0p3H78FGn4CzWgipb6zATjw6vvDmPA0BWxk04ctrXUTgt9RPa+XOhrAR3vN08OL
         fMxm/l5VjSLWv00x8G6lSnl1Uc9icv3EIKVJWyLUOcRegXupMwUL+ISGPOzFFeU3XN85
         uYcHcNte0O9WVuE8v72heMrrw2INlihsKp/Xg=
Message-ID: <e7d8f83e0808190408xc78ad97gd85a07b16750fae7@mail.gmail.com>
Date: Tue, 19 Aug 2008 21:08:55 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: douglas.leeder@sophos.com
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to a linux interface for on access scanning
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
In-Reply-To: <20080819080948.4688B3067D2@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7d8f83e0808181815v5ef628ebl3105197f03f4d334@mail.gmail.com>
	 <20080819080948.4688B3067D2@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 6:09 PM,  <douglas.leeder@sophos.com> wrote:
> malware-list-bounces@dmesg.printk.net wrote on 2008-08-19 02:15:49:
>
>> You will see latter where what you just said fails and its issue is
>> preventable too downloader with build in previewer.
>>
>> Funny enough solution to this is fairly simple.   But does require
>> looking at a white list methods and LSM.
>>
>> Two major ways.    White list format check method tells you that file
>> is not complete enough so black list scanning is not required yet.  Ok
>> lighter than running 5000 black list signatures over it each time a
>> new block gets added.
>
>
> You seem to have some very funny ideas about what white-listing and
> black-listing
> scanners do.
>
> Checking filetypes and checking for complete/non-corrupt files is
> something
> black-listing scanners do.
Pure Black List don't.   Pure Black List is looking for a known threat
that is the end of there skill.

Lot of current black list scanners are hybred.   They are using known
format white list sorting there databases.   Basically they are using
white list methods without admitting it.
>
> Where-as whitelisting:
> "An emerging approach in combating viruses and malware is to whitelist
> software which is considered safe to run, blocking all others"
>
> While ensure media files are complete could be done by a scanner that
> also does white-listing, I don't think it's a core part.
>
You are missing something critical.   Really critical.  There are such
things as Heuristic White List scanner.

Heuristic White List scanners are something you use on document
archives or for faster sorting out of a system breached by a unknown
somewhere in a stack of document files.

Major diff between Heuristic Black List and Heuristic White List.   Is
that Heuristic White List does not contain threats.   Instead
Heuristic White List contains knowledge about the formats is
processing and allowed exceptions alone.    So a doc file containing a
macro would be thrown out as a threat by a Heuristic White List unless
the Macro in the doc is included in the list of exceptions.

You find that Heuristic White List's are operating inside a lot of the
black list systems.   Reason with out it there threat processing would
simply unable to be done.

The damaged file detection in current day AV's is not black list its
white list people have mixed the two techs and want to forget the
divide.

Forced to used yet then they wrap what the white list system finds
away from the user.  Basically on the idea if they give you notice you
will do the wrong thing.  Anti-Virus companies are basically taking
the attitude to white lists is use but never show to user.

Truly operating Heuristic White List knowing file formats when it
detects something questionable gives users a few options.   Access
document without threat ie produce new copy of doc with macro striped,
 Run past a black list for that kind of threat, quarantine or delete
it.   Current AV auto set the run past black list from their Heuristic
White List.

This current auto pathing into black list has quite a few downsides.
 Black List section is going to get longer so one day processing time
will be too much again.   No way to work around signature not being
released in time.

Heuristic White List is one of the few things that can close the gap
on the black list system simple quarantine the file if user don't need
it straight up user can choose to wait a week/month before scanning it
with up to date signatures even better with like doc files and lots of
others with embeded macros lots of them document is still accessible
with it striped.    So the issue of a black list signature turning up
1 hour after getting the file will no longer be a problem for
everyone.  Users could even get use to delaying macros and exe's as
status normal in time.

Notice the effect on doc viruses when word started asking users if
they wanted to run macros.   This is a heuristic white list method.
You know there could be a threat you ask user if it is what they
expect.   This has had a far great effect on doc file viruses than any
doc related black list virus entry.   It got out of the race between
attacker and black list.

White List methods are far more developed and embedded in a lot of
locations people are blind to them.   People have got use to thinking
twice when a document asks them to allow macros.   Anyone guess the
problem here with auto black list processing.   File has been scanned
against a black list even if the user will never use the macro.  What
a waste of CPU time if there was a virus in that file it would have
never got life.

Heuristic White List embeded in online clients for incoming and out
going truly allows people to swap files with 100 percent trust.   If
the white list allows the format because it contains nothing that no
matter how fine could be a threat.   Black Listing can never be used
to offer trust over the internet.

Heuristic White List scanners date from before 1994 when I first come
across them.  Major issue then was too many formats closed spec this
has changed.   "emerging approach" that is crap.   Its been a hidden
approach that AV companies and others don't want to have to admit they
are using and that has proven itself far more effective than any black
list.  In combination with black list if the balance is right gets the
best results.   Currently all anti-virus software has the balance
wrong for most effective protection.   Also by not providing it to
users as a option is really lack of responsibility.  Lot of cases
business email and archive document storage could be covered against
viruses by a pure white list system striping all possible threats.
Effectively blocking 100 percent of all viruses threw that path in or
out due to business following standard of not archiving macros or
sending macros.   Yes its going to remove a little too much at times.

UAC is poor design.   selinux also white lists privileged operations.
catch is it remembers between reboots and does not ask user over and
over and over again for the same approvals.   That is UAC failing no
memory.  White list + memory is required so it don't drive users up
wall.  This of course is a balance again if the remembering of the UAC
like system is wrong it gets abused.  Lot of firewalls got this right
for permissions as well bug the user a lot a first after programmed
don't bug user much.  This is exactly the same job as UAC except on
networking and most operate by a white list method.

Its wrong that users hate white listing its how the white listing is done.

A black list anti-virus false positive on stacks on stacks of files it
should not be will also drive user up wall.   Either the design
functions right or it not and it has nothing todo with black list or
white list both can be screwed up in design.

White listing is heavily used without upsetting users.  Ok may upset
users at first but test of time says they will get use to it and treat
it as normal.   Do you need someone with a lot of IT history knowledge
and knowledge of different protection designs?

Peter Dolding
