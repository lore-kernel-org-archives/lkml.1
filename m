Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbYHESif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbYHESif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYHESiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:38:25 -0400
Received: from mail15.ca.com ([208.232.182.54]:46328 "EHLO mail15.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYHESiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:38:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Tue, 5 Aug 2008 14:38:23 -0400
Message-ID: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
In-Reply-To: <20080805181141.GA10700@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Thread-Index: Acj3JyAJhqVKHn65SlKTO6blbvUmWwAALqAQ
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Eric Paris" <eparis@redhat.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2008 18:38:23.0794 (UTC) FILETIME=[7114E120:01C8F72A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think you might be missing the point a bit here, as the traditional
Unix model that 
>> Linux has prevents much of what the "traditional AV" products need to
do, right?

Is your point that Linux and Unix machines are less vulnerable to
viruses?  If so, that's not relevant to my point at all.  A Unix machine
can be a carrier, passing infections on to other vulnerable platforms
(guess which one).  An enterprise security system sees the entire
enterprise as an integrated whole -- not just individual machines with
their own separate attributes and no impact on each other at all.


>>So how are you going about preventing the "infection from arriving"
>> with this proposed patchset?

I'm not endorsing or opposing the proposal until I digest it further.

However, I will say that while preventing infections from arriving is
not foolproof, doing a scan-on-close with the option to delete or
quarantine an infected file goes a long way.


Jon





-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Tuesday, August 05, 2008 2:12 PM
To: Press, Jonathan
Cc: Arjan van de Ven; Eric Paris; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
linuxinterfaceforon access scanning


A: No.
Q: Should I include quotations after my reply?

On Tue, Aug 05, 2008 at 02:04:26PM -0400, Press, Jonathan wrote:
> I'm not sure if this is off the direct idea of this thread, or if I am
> possibly missing the whole point.

I think you might be missing the point a bit here, as the traditional
Unix model that  Linux has prevents much of what the "traditional AV"
products need to do, right?

> However, I want to point out that scanning on close is still an
integral
> part of AV protection, even if intercepting opens and execs
> theoretically catches everything.

Great, then put a hook in glibc and catch all closes and then kick off
your scanning.

> You can say that there are four parts to the malware life cycle --
> getting on a machine, residing there, causing local damage, and
> propagating elsewhere.  It is part of the philosophy of AV protection
> that you do everything you can to prevent all of them.

But this proposed patchset does not do much to prevent all of these,
right?

> That's why there are scans on close, scheduled scans, and scans on
> open.  Most of our users employ all three and do not rely on one or
> two.  If an infection arrives on a machine and finds a home because it
> is assumed that it will be caught when it is opened for use, then it
> is just one more compromise away from doing damage and/or spreading.

So how are you going about preventing the "infection from arriving" with
this proposed patchset?

Isn't that something that SELinux or another LSM can prevent better?

thanks,

greg k-h

