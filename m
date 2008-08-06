Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYHFNL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYHFNL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYHFNLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:11:17 -0400
Received: from mail13.ca.com ([141.202.248.42]:40451 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYHFNLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:11:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Wed, 6 Aug 2008 09:11:14 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
In-Reply-To: <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Thread-Index: Acj3wVlUniTb8YgFSGykgIPqOI5WggAAYsVw
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805205129.37d873f0@bree.surriel.com> <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com> <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Peter Dolding" <oiaohm@gmail.com>
Cc: "Rik van Riel" <riel@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 06 Aug 2008 13:11:14.0312 (UTC) FILETIME=[E7696080:01C8F7C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Peter Dolding [mailto:oiaohm@gmail.com] 
Sent: Wednesday, August 06, 2008 8:39 AM
To: Press, Jonathan
Cc: Rik van Riel; Greg KH; Arjan van de Ven; Eric Paris;
linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
linuxinterfaceforon access scanning

On Wed, Aug 6, 2008 at 10:10 PM, Press, Jonathan <Jonathan.Press@ca.com>
wrote:
> -----Original Message-----
> From: Rik van Riel [mailto:riel@redhat.com]
> Sent: Tuesday, August 05, 2008 8:51 PM
> To: Press, Jonathan
> Cc: Greg KH; Arjan van de Ven; Eric Paris;
linux-kernel@vger.kernel.org;
> malware-list@lists.printk.net; linux-security-module@vger.kernel.org
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
> linuxinterfaceforon access scanning
>
> On Tue, 5 Aug 2008 14:38:23 -0400
> "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
>
>> However, I will say that while preventing infections from arriving is
>> not foolproof, doing a scan-on-close with the option to delete or
>> quarantine an infected file goes a long way.
>
> How can you, as a security professional, argue for a security measure
> that you know is flawed, when there is a mailing list full of people
> willing to help figure out what a working security measure would look
> like?
>
> Yes, abandoning some of the old DOS anti-virus security model may
cause
> work, but surely that will be worth it if it leads to a more secure
> system?
>
>
> [JON PRESS]  I hesitate to join back in the discussion, because so far
I
> haven't been very successful.  I know that my level of technical depth
> is not at all the equal of just about everybody else in this
> conversation.  That's not my job and I don't claim to have the answers
> to all the questions that are being raised.
>
> However...  This question about arguing for a flawed security
technique
> is a good one, and in a way it gets to the heart of the philosophy of
> security.  Scan-on-close is admittedly incomplete as an anti-virus
tool.
> But I don't agree that that make it flawed.   It is part of a
repertoire
> of techniques for preventing malware from residing on a machine.
>
> Let's take a simplistic and unrealistic example.  Let's suppose that
you
> knew that there were 20 applications on your machine that had buffer
> overflow vulnerabilities that could be exploited, and you had a fix
for
> 18 of them.  Would you decide not to apply the fixes, because that
meant
> that there would still be 2 left -- and because theoretically there is
a
> way to prevent all buffer overflows from being exploited and there is
a
> mailing list full of people trying to figure out how to do it.
>
This buffer overflow risk and other equals are why LSM's exist.   It put
jails around applications so they cannot do any more than they are meant
to.   Its called risk reduction something that is most likely a new idea
to people coming from a windows background.   It also makes exploiting a
flawed applicaiton tricky.  Do something that application should not
normally do it will be blocked and trip the LSM alarm that
could be set to straight up terminate the offending application.   Yes a
true shot on sign of trouble system.  This is what you anti-virus guys
call behaviour monitoring same system some anti-virus software uses to
detect unknown viruses.

So 2 left should never happen since we have at least a part fix for all
of them.   This is how it has to work.   Failure is not a option in our
eyes.   If you have a percent missed that is a failure of there is not
something else to prevent damage.  We are not Windows users with weak
setup systems.   We don't want weak distributions out there.  Nice if
some anti-virus products started demanding a min standard LSM to run
side by side with them.

LSM's are already embedded core system exploitation prevention.

LSM currently don't extend deep enough into users to really tighten
completely down on the Users account.

So far I have not found a exact list of what is needed by AV or Malware
companies that say LSM stacking is needed.  That says stacked LSM's are
needed.

So I will bring a few things to the table.  Number one LSB is working on
a common packaging API using DBUS based off policy kit.   So malware
application installers run in users own account and to install into the
system have to go threw a scan able interface.   So far I have not seen
AV companies there working in improving the design. Prevention beats
cure.

This reduces a issue of malware to the Users own account without heavy
handed scanning.

So scanning becomes reduced to user editable files.

Linux firewall supports user mode modules so antivirus can scan network
traffic and use built in firewall to monitor for malware.

File scanning look no deeper than fusefs.
http://clamfs.sourceforge.net/.   Alter the automount system to wrap
this over the top of user mounted file systems and locations of user
editable and your are done.

Now credentials patch that has not got mainline yet also provides user
mode daemon support to override filesystem permissions.  Could also be
integrated into a Anti Virus Scanner.  credentials is not a LSM really
its centralisation of permission information so its no longer speed all
over the kernel.

There are sections in containers as well that could cover bits..

TPM segments appear in 2.6.27 as well that will also make a core system
breach harder.

Now please layout what you need Anti-Virus Companies.  Don't use
clueless desktop users as a reason.   Linux could already provide the
needed interfaces just not LSM.

Now please provide a detailed list of exactly what you need Anti-virus
companies.   Most likely everything you need already exists mainline or
in a development side line.  Extra coders to get some of those features
mainline would be good.


[JON PRESS]  First of all, my examples were just hypothetical examples
designed to set a context.  If they don't work, then don't take them too
literally.

Second, I'll try to put another way.  The disease analogy for computer
viruses, though perhaps overused, actually goes a surprisingly long way.
The kernel guys are like medical researchers, and the AV guys (or at
least speaking for myself) are in Public Health.  You guys are looking
at the human body (the computer) and looking for its low-level
vulnerabilities and ways to protect against them.  We are working in the
context of imperfect human behavior that often causes people to get sick
in spite of the current state of medical knowledge, and occasionally
causes things to get out of control.  Neither point of view is incorrect
-- but each attacks a very different aspect of the problem.

And this goes right to the heart of the statement "prevention beats
cure".  That's true in the long run, but it's not true if you're already
sick -- or your neighbor is, and prevention is still a few years away.

Third, regarding stating what we need, we actually already had a
discussion about this several months ago, where we described this.  That
discussion was the basis for Eric's proposal.  To give it some
perspective, here is how I understand the flow of events.  As Eric
described in his original posting this week, in the past many products
(AV, along with others that have needed access to similar events --
representatives of which have been participating in this discussion)
have done their own tricks to get at i/o events that they need to
trigger some action.  Many do this by modifying the syscall table.  We
were told that this was going to become an invalid operation in a coming
release of Red Hat Linux, and Red Hat offered to have a discussion with
us on what could be done to offer us another way into the same
information.  This seemed like a very positive direction to go in, and
there was a discussion about what this alternative ought to look like.
On the basis of this discussion, Eric then went off and worked on the
design that he has presented.  

There was probably an implicit assumption on everyone's part, including
Red Hat's, that what ought to be done was to replace the existing
syscall-based event trapping with some other interface that more or less
does the same thing in a cleaner way -- NOT to have all of the AV and
other product vendors go out and completely rethink their models.  And
that's not because we inherently object to rethinking.  It's really an
issue of what kind of time frame we have before a new OS goes out that
completely breaks our products.  Rethinking the entire model and
developing all new products along different paradigms is not a bad thing
to do, but it takes a lot of time.  Frankly we're always doing that in
some way.  However, there is a more pressing problem at hand, and that's
what Eric's spec is meant to solve.


Jon

