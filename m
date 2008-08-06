Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYHFMO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYHFMO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYHFMK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:10:56 -0400
Received: from mail12.ca.com ([141.202.248.38]:27043 "EHLO mail12.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbYHFMKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:10:54 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Wed, 6 Aug 2008 08:10:53 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
In-Reply-To: <20080805205129.37d873f0@bree.surriel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Thread-Index: Acj3XwE/lXSRpRKKS/mJ9SsRYZLZLQAWjCIA
References: <20080805103840.1aaa64a5@infradead.org><2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com><20080805181141.GA10700@kroah.com><2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805205129.37d873f0@bree.surriel.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Rik van Riel" <riel@redhat.com>
Cc: "Greg KH" <greg@kroah.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 06 Aug 2008 12:10:53.0849 (UTC) FILETIME=[79729090:01C8F7BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Rik van Riel [mailto:riel@redhat.com] 
Sent: Tuesday, August 05, 2008 8:51 PM
To: Press, Jonathan
Cc: Greg KH; Arjan van de Ven; Eric Paris; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
linuxinterfaceforon access scanning

On Tue, 5 Aug 2008 14:38:23 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> However, I will say that while preventing infections from arriving is
> not foolproof, doing a scan-on-close with the option to delete or
> quarantine an infected file goes a long way.

How can you, as a security professional, argue for a security measure
that you know is flawed, when there is a mailing list full of people
willing to help figure out what a working security measure would look
like?

Yes, abandoning some of the old DOS anti-virus security model may cause
work, but surely that will be worth it if it leads to a more secure
system?


[JON PRESS]  I hesitate to join back in the discussion, because so far I
haven't been very successful.  I know that my level of technical depth
is not at all the equal of just about everybody else in this
conversation.  That's not my job and I don't claim to have the answers
to all the questions that are being raised.

However...  This question about arguing for a flawed security technique
is a good one, and in a way it gets to the heart of the philosophy of
security.  Scan-on-close is admittedly incomplete as an anti-virus tool.
But I don't agree that that make it flawed.   It is part of a repertoire
of techniques for preventing malware from residing on a machine.

Let's take a simplistic and unrealistic example.  Let's suppose that you
knew that there were 20 applications on your machine that had buffer
overflow vulnerabilities that could be exploited, and you had a fix for
18 of them.  Would you decide not to apply the fixes, because that meant
that there would still be 2 left -- and because theoretically there is a
way to prevent all buffer overflows from being exploited and there is a
mailing list full of people trying to figure out how to do it.

I think if it as being like the Sieve of Eratosthenes.  The further down
you go, the more numbers drop out.  In AV scanning, each step of the way
removes some percentage of the harmful files, and closes the window of
time that they have to operate or migrate.  Or maybe it's like spraying
insecticide when there is an outbreak of some deadly mosquito-borne
illness.  Without getting into the political issues about spraying,
because this is JUST AN EXAMPLE -- would you not spray because 5% of the
bugs would still be left behind?  Wouldn't you then spray again, because
you wipe out another 95%?

If this were not the case, why would so many of our customers run
scheduled system scans on a regular basis in addition to scanning on use
and scanning on close?  There are several reasons, including the
constant evolution of malware, the possibility that a machine's
protection was temporarily disabled for some reason, etc.  The point is
that catching malware as close to the time it is written as possible is
a net gain that adds to the overall level of protection.

Hopefully, in addition to discussing the particular question that was
raised in Rik's email, this also sheds some light on how I look at the
overall problem -- i.e., from a higher more conceptual level of
functionality and value, rather than the low-level technical specifics.

