Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYHMVYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYHMVYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHMVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:24:30 -0400
Received: from mail13.ca.com ([141.202.248.42]:40414 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYHMVY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:24:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Wed, 13 Aug 2008 17:24:28 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
In-Reply-To: <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj9gYK+BBaa6rzKQEiZpMYM5g7Z7QACM1sg
References: <1218645375.3540.71.camel@localhost.localdomain><20080813172437.3ed90b0d@lxorguk.ukuu.org.uk><1218646065.3540.75.camel@localhost.localdomain><20080813173722.13c9c306@lxorguk.ukuu.org.uk><1218646833.3540.82.camel@localhost.localdomain> <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Eric Paris" <eparis@redhat.com>
Cc: <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>, <hch@infradead.org>,
       <andi@firstfloor.org>, <viro@ZenIV.linux.org.uk>, <arjan@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 21:24:28.0530 (UTC) FILETIME=[F7D4ED20:01C8FD8A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> bounces@dmesg.printk.net] On Behalf Of Alan Cox
> Sent: Wednesday, August 13, 2008 3:59 PM
> To: Eric Paris
> Cc: peterz@infradead.org; linux-kernel@vger.kernel.org; malware-
> list@lists.printk.net; hch@infradead.org; andi@firstfloor.org;
> viro@ZenIV.linux.org.uk; arjan@infradead.org
> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
> 
> > > I don't think you need to be blocking if you passed up a file
handle ?
> >
> > Without blocking and waiting how do you deny access?  Maybe I needed
> > another thing they do.  "They do file scanning and deny access to
bad
> > files."
> 
> Denying access is easy enough - chmod it or set an SELinux label on
it.

I may be missing something about your suggestion, but I don't see how
this would work.  Who does the chmod?

Here's a sequence:

- Application opens file
- AV scanner notified in some way without blocking
- Application reads file into memory
- AV scanner determines file is infected.
- AV scanner chmod's file -- oops, too late.
- Application sends file over the wire to another machine with a more
vulnerable OS

How would this be prevented?


Jon Press
