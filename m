Return-Path: <linux-kernel-owner+w=401wt.eu-S1765584AbYHEVX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765584AbYHEVX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765134AbYHEVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:23:43 -0400
Received: from mail15.ca.com ([208.232.182.54]:57867 "EHLO mail15.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765500AbYHEVXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:23:42 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforonaccess scanning
Date: Tue, 5 Aug 2008 17:23:39 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
In-Reply-To: <20080805211445.GA28304@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforonaccess scanning
Thread-Index: Acj3QJsLMBWgpFdLRZmPydQmCGhVIQAABB/Q
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Theodore Tso" <tytso@mit.edu>, "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2008 21:23:40.0486 (UTC) FILETIME=[87E3FE60:01C8F741]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Tuesday, August 05, 2008 5:15 PM
To: Press, Jonathan
Cc: Theodore Tso; Arjan van de Ven; Eric Paris;
linux-kernel@vger.kernel.org; malware-list@lists.printk.net;
linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
alinuxinterfaceforonaccess scanning

On Tue, Aug 05, 2008 at 04:37:42PM -0400, Press, Jonathan wrote:
> 
> [JON PRESS]  I don't get the connection between what I said and your
> point about not needing blocking open() interface.  If I ftp into a
> Linux machine and GET an infected file, you want FTP to go right ahead
> and read it and send it to me over the wire?

Shouldn't that be the issue of the FTP server itself not serving up
"invalid" files, and not the kernel?  Why not just hook in it, I'm
pretty sure they already provide this kind of interface, right?


[JON PRESS]  So how would that work?  The FTP server would have code
that called into someone's AV SDK (maybe CA's, maybe not) and scanned
the file before sending.  OK.  What about all the thousands of other
applications that might access a file and send it somewhere, or copy it
somewhere.  They should all do the same thing, right?  How do we make
that happen?  That's the whole point of centralizing the control (the
notification, blocking and waiting -- not the actual scanning, of
course) in the kernel.  The scan becomes unavoidable -- and that is the
definition (OK, a definition) of true security.


