Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYHTDER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYHTDER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 23:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYHTDEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 23:04:00 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:64687 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbYHTDD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 23:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U+iOxrWtlTB+/95cfs8gi1Gph9GcC8vSwS1R3OT+98dF0GqmDucwrd+L53UnDyEFcb
         zv5n6g6jLNJzhD0nYdHpN9WG/4ba8ON4HzyPju74VySXeFPP8i75XKTUj6SsOfw3243d
         oinPXs5X0RJdqyb9Zlu5g1cWmjcGig95LY3F4=
Message-ID: <e7d8f83e0808192003m3ff003fcma2ea5dd74212af69@mail.gmail.com>
Date: Wed, 20 Aug 2008 13:03:58 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: james.lyne@sophos.com
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to a linux interface for on access scanning
Cc: douglas.leeder@sophos.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net
In-Reply-To: <20080819114040.2FD1B336880@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7d8f83e0808190408xc78ad97gd85a07b16750fae7@mail.gmail.com>
	 <20080819114040.2FD1B336880@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 9:40 PM,  <james.lyne@sophos.com> wrote:
>
> As for the example you have given with macro viruses, I disagree that this
> is whitelisting. In this case, the application which originally introduced a
> specific class of security risk added additional controls and warnings to
> prevent abuse. This was a good feature and should be encouraged, but I don't
> believe this constitues whitelisting. This is comparable perhaps to some of
> the moves made by Firefox to generically detect abuse of their script
> runtime and alert the user of supsicious activities.
>
Its a class of white listing under developed.  Just because the
application created the thread does not change there answer.   For a
time some of these programs also tried answering with built in black
lists as well the black list methods have failed and the white list
method remains as the winner.  Firefox is basically building in a form
of whitelisting.    Heuristic White listing is about suspicious not
about exact threat identification.

Major issue is simple.  I will give some examples where white listing
along comes into its own.   Issue is lots current scanners don't even
allow user to go that path.

Lets say I have a file store of documents like letters spread sheets
and  so on  being kept for archival reasons.   This documents can
exist executable code free and needed to exist damage free.   No
executable code no viruses/trojans/trouble also no executable code is
good for long term archives since the processing of executable code
could change.  Damage free removes buffer overflow and damaged format
attacks.   Current Anti-viruses take the line I must scan and rescan
against a black list.  This has effectively means a 100 GB archive
becomes imposable to scan and give a clean rating to because its a
never ending process.  White list scanning the archive is not a never
ending process only time it has to be redone is if the White List
scanner was imperfect for the formats in the archive ie missed some
executable or buffer overflow/damaged sections in the formats it
knows.   This is 100 percent a failure to provide what is needed by
anti-virus companies.

Emails and IM more people don't normally intentionally send executable
code to each other.  White listing using format aware scanner  here is
a great stop unknown threats straight up  even question user about
unknown format they are receiving most users would not take as a bad
thing.

Anti-virus companies complain about Linux not providing them with a
stable api to integrate into Linux kernel.   Anti-virus companies are
also guilty of the reverse to Download, IM and Email programs.   No
stable common api for developers to use your products instead you hack
in.   Really you need to be working hand and hand with these programs.
 Reason with a lot of these programs the transferred data itself may
start being access and running before its transferred out of memory
and before you get a chance to scan it particularly as encryption
becomes more heavily used.   Stable API on both sides helps everyone.

Sorry to say mass installed Linux clients working off a central update
server white listing the complete network is simple.   All updates are
coming threw one location.  Black list scanning the update server
effectively scans all installed applications if the network is locked
down.  So as long as white list scanning is maintained on the clients
of the business update server preventing anything else from entering
the network is protected.   Same kind of thing can be done with
windows but since you cannot simply jack the white list system into
the update server its harder.

Part of the way forward is accepting that scanning techs are two
halfs.   White lists and Black Lists.   Next is accepting that at
times users need White List suspicious answers more than Black List
this is the threat answers.   Then working out how to give them White
List scanning in a controlled way.   User being able to set how the
anti-virus responds when it gets a White List suspicious answer.
Some users will stick with the status now of white list suspicious
going straight into black list.   Others due to different needs will
choose to do the other things like

1. Quarantine amount of time to get a more up to date scanner.   This
is particularly useful if user has just connected there laptop to the
internet after a while off line and has downloaded there emial before
the anti-viruses black lists are updated or for some reason users
cannot update there anti-virus due to server issues.   Users still
need to be able to use email and other things safely.  Current black
list forced path is failing users since if the black list passes the
white list suspicious from looking at the format is disregarded.

2.  User knows a section of there storage that should not contain
anything that a white list should detect.  So alteration there is a
threat id of the threat is not high up list.   Becides if its a
unknown threat current method see it slip threw.   Of course any
detection like this should offer to go threw black list for format ID
and only clear if user approves.   Not the current auto pass of the
current hook up.

Corrupted identification is a white list methods.   Started off with
like the likes of validators these tools know the file formats they
are looking at and sort out damaged from undamaged.  When doing data
recovery most people don't have a nice list of checksums to give you
instead you need to sort out what files are still usable this is where
validators come in.   There is no list part to a validator only thing
it knows is the format itself slightly altered validators become white
list heuristic scanners ie lots of added if this is present don't
trust the file.   Basically over time more and more white list methods
have drifted into anti-virus engines.   Big issue you have forgotten
that they are not Black List.

Sorting Black and White list methods is dead simple.   Its the
information you need to create them.  If you need to know about the
evil stuff to create them you are in Black List.   If you only need to
see above board stuff like specs for formats you are in white list.
People have forgot the divide.   Its also critical to remember due to
both have different advantages and disadvantages.

Advantage of the White List Group 100 percent detection of threats is
achievable and is slower growing database if you use heuristic
methods.  Disadvantage of White List Group used in the set-up alone
can block too much ie Can have a higher false positive rate.

Advantage of the Black List Group low false positive rate.
Disadvantage can have a false negatives.

Using white list checksum methods really large storage required and is
infective against user created documents to the same level black lists
checksum based are useless against user created documents.

Basic threat detection design.   White List then anything rejected
must Pass threw Black List before being allowed run.    Now deleting
before passing threw black list has to be acceptable.

Users are asking for 100 percent protection from viruses where able.
The tech to give them that at a price has existed for years.   About
time White List Heuristics are given to end users as a tool to use if
it suits there current setup.   This is allowing users at there own
choosing to get ahead of the attackers.

Peter Dolding
