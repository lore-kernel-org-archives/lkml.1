Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYHFMiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYHFMiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYHFMih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:38:37 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:52104 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYHFMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KcjAuZsPFEdo7iuMJ+bcM394fKDjjkKSLthkAxysHtTmXvH+1gdLp81gn2a32DTzyT
         a3tw7T5dVYdNtE0OlEFD/BN/y0XIBjexGtlYcxkHk1oMHB09iFFkwlPHckMWGK6Dfeal
         LAWv/ks7DFsppBpLF5O1P4cOzw7DqEErArOdI=
Message-ID: <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
Date: Wed, 6 Aug 2008 22:38:33 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Cc: "Rik van Riel" <riel@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805181141.GA10700@kroah.com>
	 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805205129.37d873f0@bree.surriel.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 10:10 PM, Press, Jonathan <Jonathan.Press@ca.com> wrote:
> -----Original Message-----
> From: Rik van Riel [mailto:riel@redhat.com]
> Sent: Tuesday, August 05, 2008 8:51 PM
> To: Press, Jonathan
> Cc: Greg KH; Arjan van de Ven; Eric Paris; linux-kernel@vger.kernel.org;
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
> Yes, abandoning some of the old DOS anti-virus security model may cause
> work, but surely that will be worth it if it leads to a more secure
> system?
>
>
> [JON PRESS]  I hesitate to join back in the discussion, because so far I
> haven't been very successful.  I know that my level of technical depth
> is not at all the equal of just about everybody else in this
> conversation.  That's not my job and I don't claim to have the answers
> to all the questions that are being raised.
>
> However...  This question about arguing for a flawed security technique
> is a good one, and in a way it gets to the heart of the philosophy of
> security.  Scan-on-close is admittedly incomplete as an anti-virus tool.
> But I don't agree that that make it flawed.   It is part of a repertoire
> of techniques for preventing malware from residing on a machine.
>
> Let's take a simplistic and unrealistic example.  Let's suppose that you
> knew that there were 20 applications on your machine that had buffer
> overflow vulnerabilities that could be exploited, and you had a fix for
> 18 of them.  Would you decide not to apply the fixes, because that meant
> that there would still be 2 left -- and because theoretically there is a
> way to prevent all buffer overflows from being exploited and there is a
> mailing list full of people trying to figure out how to do it.
>
This buffer overflow risk and other equals are why LSM's exist.   It
put jails around applications so they cannot do any more than they are
meant to.   Its called risk reduction something that is most likely a
new idea to people coming from a windows background.   It also makes
exploiting a flawed applicaiton tricky.  Do something that application
should not normally do it will be blocked and trip the LSM alarm that
could be set to straight up terminate the offending application.   Yes
a true shot on sign of trouble system.  This is what you anti-virus
guys call behaviour monitoring same system some anti-virus software
uses to detect unknown viruses.

So 2 left should never happen since we have at least a part fix for
all of them.   This is how it has to work.   Failure is not a option
in our eyes.   If you have a percent missed that is a failure of there
is not something else to prevent damage.  We are not Windows users
with weak setup systems.   We don't want weak distributions out there.
 Nice if some anti-virus products started demanding a min standard LSM
to run side by side with them.

LSM's are already embedded core system exploitation prevention.

LSM currently don't extend deep enough into users to really tighten
completely down on the Users account.

So far I have not found a exact list of what is needed by AV or
Malware companies that say LSM stacking is needed.  That says stacked
LSM's are needed.

So I will bring a few things to the table.  Number one LSB is working
on a common packaging API using DBUS based off policy kit.   So
malware application installers run in users own account and to install
into the system have to go threw a scan able interface.   So far I
have not seen AV companies there working in improving the design.
Prevention beats cure.

This reduces a issue of malware to the Users own account without heavy
handed scanning.

So scanning becomes reduced to user editable files.

Linux firewall supports user mode modules so antivirus can scan
network traffic and use built in firewall to monitor for malware.

File scanning look no deeper than fusefs.
http://clamfs.sourceforge.net/.   Alter the automount system to wrap
this over the top of user mounted file systems and locations of user
editable and your are done.

Now credentials patch that has not got mainline yet also provides user
mode daemon support to override filesystem permissions.  Could also be
integrated into a Anti Virus Scanner.  credentials is not a LSM really
its centralisation of permission information so its no longer speed
all over the kernel.

There are sections in containers as well that could cover bits..

TPM segments appear in 2.6.27 as well that will also make a core
system breach harder.

Now please layout what you need Anti-Virus Companies.  Don't use
clueless desktop users as a reason.   Linux could already provide the
needed interfaces just not LSM.

Now please provide a detailed list of exactly what you need Anti-virus
companies.   Most likely everything you need already exists mainline
or in a development side line.  Extra coders to get some of those
features mainline would be good.



Peter Dolding


PS how to I get my email on the malware-list@lists.printk.net  So it
does not bounce things to me.
