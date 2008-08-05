Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYHEUhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYHEUhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYHEUho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:37:44 -0400
Received: from mail13.ca.com ([141.202.248.42]:14822 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYHEUhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:37:43 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Date: Tue, 5 Aug 2008 16:37:42 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
In-Reply-To: <20080805185438.GA8453@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Thread-Index: Acj3LLuW3asq0K4LQJ+rKcDzLJzuywADZuRw
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: "Greg KH" <greg@kroah.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2008 20:37:42.0279 (UTC) FILETIME=[1BDF0170:01C8F73B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Theodore Tso [mailto:tytso@mit.edu] 
Sent: Tuesday, August 05, 2008 2:55 PM
To: Press, Jonathan
Cc: Greg KH; Arjan van de Ven; Eric Paris; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
alinuxinterfaceforon access scanning

On Tue, Aug 05, 2008 at 02:38:23PM -0400, Press, Jonathan wrote:
> Is your point that Linux and Unix machines are less vulnerable to
> viruses?  If so, that's not relevant to my point at all.  A Unix
machine
> can be a carrier, passing infections on to other vulnerable platforms
> (guess which one).  An enterprise security system sees the entire
> enterprise as an integrated whole -- not just individual machines with
> their own separate attributes and no impact on each other at all.

Sure, but if that's the case, you don't need to have a blocking open()
interface.  Having inotify tell your application that a file
descriptor that had been opened for writing has been closed
(IN_CLOSE_WRITE) should be quite sufficient.


[JON PRESS]  I don't get the connection between what I said and your
point about not needing blocking open() interface.  If I ftp into a
Linux machine and GET an infected file, you want FTP to go right ahead
and read it and send it to me over the wire?

