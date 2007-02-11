Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXBKJuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXBKJuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 04:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXBKJuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 04:50:52 -0500
Received: from usbb-lacimss1.unisys.com ([192.63.108.51]:3681 "EHLO
	usbb-lacimss1.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXBKJuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 04:50:51 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 04:50:51 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Data Caching Service
Date: Sun, 11 Feb 2007 14:50:43 +0530
Message-ID: <D566E8CF3538B54D95B925CB69CB4D2A01E80319@inblr-exch1.eu.uis.unisys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Data Caching Service
Thread-Index: AcdBJ5uL70rxUgzzSeKZD9iR5SIK1gAC/EYQAyKH6eA=
From: "Satapathy, Soumendu Sekhar" <Soumendu.Satapathy@in.unisys.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Feb 2007 09:20:47.0561 (UTC) FILETIME=[EA221B90:01C74DBD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



 
-----Original Message-----
From: Satapathy, Soumendu Sekhar 
Sent: Friday, January 26, 2007 4:10 PM
To: 'Andrew Morton'
Subject: RE: Data Caching Service

Yes I agree with you. 

Even if we could do this without the kernel being involved, the
applications have to be aware of these details. Could it have been done
without the application's knowledge ?

The Kernel provides an environment/platform for the applications to run
and hence ideally as far as possible, performance issues related to
caching etc should be under the kernel's jurisdiction.

Currently I am talking at the philosophy level so I just wanted the
concept to make sense.  

thanks
soumendu 

 
-----Original Message-----
From: Andrew Morton [mailto:akpm@osdl.org] 
Sent: Friday, January 26, 2007 2:24 PM
To: Satapathy, Soumendu Sekhar
Subject: Re: Data Caching Service

On Fri, 26 Jan 2007 14:05:04 +0530
"Satapathy, Soumendu Sekhar" <Soumendu.Satapathy@in.unisys.com> wrote:

> Hi,
> 
>  
> 
> I was just trying to work out on a Philosophy, where the Application
> designer, should not bother about performance issues related to any
kind
> of
> 
> caching. Even if Data Caching is a simple phenomenon of just storing
> data in memory for quick access, we don't want the application
designer
> 
> to bother about that. Application designer should bother about only
one
> thing and that is , the business logic for which they are writing the 
> 
> application. 
> 
>  
> 
> Of course we do have some language features which implements this
.Will
> it be prudent for the Kernel to take care of all issues related to
> caching ? 
> 
> Can a robust kernel be implemented to realize this?
> 
>  
> 
> I am attaching a small draft with this mail. Will it be possible for
you
> to just scroll it down in your free time ? If you feel that a variant
of
> such
> 
> a scheme if implemented can be of some help to linux,  then maybe we
> could release some useful patches.  
> 

hm.  But applications can utilise a common cache via shared libraries,
and shared memory
without involving the kernel.
