Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYHRNkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYHRNkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYHRNkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:40:09 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:48801 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYHRNkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r9Ah5EfVWPIg+CdxfWc5srqeil0IRhHRlsLeFeb9UYHhD0VDkIrmHBGykI5sp+RwvE
         kMeavEFkqB0oluP+raR4vLePjHBJoAGZHrxwizwx8JWlN7v2I433Ut1z49Gzii8J3I6o
         uou42lO7qHpYCVzm3K0ovL3QgIaSZ1/4p5xQU=
Message-ID: <e7d8f83e0808180640y76e60b96t42c9c23ca2245b09@mail.gmail.com>
Date: Mon, 18 Aug 2008 23:40:05 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: douglas.leeder@sophos.com
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
In-Reply-To: <20080818105417.1EE932FE865@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7d8f83e0808171711y3a60b0d2s4e4770bf4c362bc9@mail.gmail.com>
	 <20080818105417.1EE932FE865@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 8:54 PM,  <douglas.leeder@sophos.com> wrote:
> malware-list-bounces@dmesg.printk.net wrote on 2008-08-18 01:11:24:
>
>> In answer to the small enough set of files idea.   The simple issue is
>> that one time cost of black list scanning gets longer and longer and
>> longer as the black list gets longer and longer and longer.   Sooner
>> or latter its going to be longer than the amount of time people are
>> prepared to wait for a file to be approved and longer than the time
>> taken to white list scan the file by a large margin.  It is already
>> longer by a large margin to white list scanning.    CPU sizes not
>> expanding as fast on Linux kind brings the black list o heck problem
>> sooner.   Lot of anti-virus black lists are embeding white lists
>> methods so they can operate now inside the time window.   The wall is
>> coming and its simply not avoidable all they are currently doing is
>> just stopping themselves from going splat into it.  White list methods
>> will have to become more dominate one day there is no other path
>> forward for scanning content.
>
> The problem with white-lists is who gets to decide what's on them:
>
> a) The end-user: Easy to get around - a social engineering attack.
>        The problem is if you make all the good applications the
>        user downloads appear identical to any random malware they
>        download, the end-users will treat them the same.
>
> b) The network administrator: Often doesn't exist (e.g. home users), but
>        even when they do exist, they are often too over-worked to
>        handle a white-listing solution. For example Windows provides
>        white-listing in policies (AFAIK), but still there is a market
>        for AV software.
>        The admin probably ends up authorizing anything the end-users
> want.
>                (Thus leading to the same problems as a)...)
>
> c) The White-listing software company: Now has to maintain a perfect
> database
>        of known-good software, without letting in any malware.
>        Also problems with edge-cases such as adware.
>        Also needs some way of handling private software, and
> self-compiled software.
>                (which probably leads to a) or b)...)
>
> d) Third-party: All the problems of c) with more trust issues, plus
>        iphone-ish lock-in problems.
>
> The other problem that I can see is that white-list scanners have to be
> much more exact on the matching (either checksums or signatures), as the
> malware authors will be trying to look-like authorized software.
>
> black-list scanners can afford heuristic detection, because good-software
> authors
> aren't trying to look like malware.

I can cover all of these.

Type A) White Lists for stand alone end users would normally operate
with a matching black list system.  White list system would be
detecting known damaged file formats and possable threats in the
process letting files that cannot contain viruses/malware pass.
Really its a waste of time scanning a damaged file users need to be
informed of it as well a equally waste of time black list scanning a
file for viruses/malware that cannot carry threats.  Also new unknown
executable files being placed before user to approve to go on for
black list scanning or remove from system really does cut down threat
to system.   User is engaged in there own protection.   User normally
knows if they are attempting to run a new program or not, Asking them
is the white list way.   Don't just presume they are meaning to run a
new exe they have never run before scan it for what threat you know
then let it run.  Reason black lists are flawed we know they are
flawed.  So we use the user to give a extra level of filtering.

Type B and C) For companies have you seen the paper work for getting
software into lots of businesses with system admins.   The ammount of
tracking that has to be done on software installed.   Keeping a white
list system that is also doing installation head counts is not that
much of a overhead.   Internally created software normally has to go
threw approval processes before actively deployed every where.
Keeping a white list just fits into general operations of quite a few
businesses with system admins.  Just a lot don't notice it in the
paper work they are doing.   Like complete lists of installed
software.  This is more good design of the white list system as well
as scanning the system it is doing the needed network audits both are
overlapping processes.

D) we currently have that issue with anti-virus software black list.
I had my test network software deleted, my documentation how to by
pass a old alpha servers password deleted.  All by black list
anti-virus being over picky.  We already have anti-virus lock in with
black list white list really does not change it.

Checksums and Signatures are not the only ways of white listing.
Sections of white lists is heuristic as well.   These are format
matches.   If you have a word document that does not contain macros is
defect free for all its images and parts.   You really don't need a
checksum or a Signature for it.   You really just need a way of
acquiring that the file is clean of all possible threats in the white
list system.

Even against black lists malware trys to show up as good software or
worse stuff black lists false positive on so black list scanner
disregards it.  heck some malware sites have gone as far as saying
disable anti-virus before installing in process detect black list
scanner and root kit it.   Even some above board software tells you to
disable you black list scanner so it does not false positive.
heuristic's in black list scanners is unstable.

White list systems also block from running like part executables from
the executable format itself.   Likes a broken downloads.  These can
be just as harmful as to user data as any virus.   Yet most current
day black list systems let them slide.  Damaged files are a threat to
stable operation of a machine sometimes worse than been malware
infected.   Part install from a damaged installer of a perfectly safe
program can bring the computer down just as effectively as any trojan
slipping past black list scanners.

Heuristic's in White List scanners is stable.  Yes we know they can
throw out too much.   The important thing they throw out stuff black
list scanners let slide.

White list methods have to come to at least pull out damaged files
before they can do system harm.  Remember fuzzing random data files
shoved into a file until it finds a defect in its file format.  White
list works on detecting files with defects and binning them taking
viruses and other threats using those methods out of the threat
matrix.   This is theat reduction.  With white list format processing
less and less threat paths are left usable to attackers.   Closing the
exe threat path for home users is extremely hard.   Closing the exe
threat path for business fairly straight forward.  Total population of
infect able machines reduced by quite a number.

Major reason why AV companies will not want to do this.  Is simple if
file formats by a business have not changed and no flaws found in the
white list scanner most likely business will have no reason to update
more often than the software they use since white list scanner will
maintain its effectiveness against threats.   Attackers generating
more and more viruses don't expand the white list zone to protect.

Peter Dolding
