Return-Path: <linux-kernel-owner+w=401wt.eu-S1765177AbYHEUUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765177AbYHEUUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763750AbYHEUPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:15:37 -0400
Received: from mail14.ca.com ([208.232.182.53]:12380 "EHLO mail14.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763978AbYHEUPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:15:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Tue, 5 Aug 2008 16:15:32 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com>
In-Reply-To: <20080805183845.GA11375@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Thread-Index: Acj3OAiV6liJp0XsRXenVevvD6fshw==
References: <20080805112747.2c3c4650@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com> <20080805183845.GA11375@kroah.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Eric Paris" <eparis@redhat.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2008 20:15:33.0390 (UTC) FILETIME=[03CAA2E0:01C8F738]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Tuesday, August 05, 2008 2:39 PM
To: Press, Jonathan
Cc: Arjan van de Ven; Eric Paris; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
linuxinterfaceforon access scanning


A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

On Tue, Aug 05, 2008 at 02:34:26PM -0400, Press, Jonathan wrote:
> You're right...I am not talking about blocking at all -- which may be
a
> further indication that I am missing the specific point of this
thread.
> 
> But be that as it may...  I don't want to have to use more than one
> interface to get all the events I am interested in.  I want to
register
> as a client and listen, and get everything I need from the same place.

That's an implementation issue, not a requirement.  If it's a
requirement, it sure is a lazy one :)


[JON PRESS]  I wouldn't call it lazy, actually.  It's more like
"economical" or "ergonomic" -- or, dare I say it -- "user-friendly."  In
this case, the users are the AV vendors who will have to write to the
API that will come out of this spec.  We will be more inclined to
appreciate the SDK (for want of a better term) if it covers all the
bases, rather than force us to go elsewhere for some of our
requirements.  When we write SDKs, we try to make sure that our users
will find whatever they need.



> Also, it seems to me that for my purposes, close is discrete enough.
It
> tells me that there is now something out there that should be looked
at.

So, if you hook glibc to catch all calls to close, is that sufficient?

[JON PRESS]  Let's see...I'm going to use inotify for some events, glibc
for others, and this API for the rest.  Would you really want to write
an application like that?

