Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbXBKJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbXBKJxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 04:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXBKJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 04:53:20 -0500
Received: from usbb-lacimss2.unisys.com ([192.63.108.52]:2467 "EHLO
	usbb-lacimss2.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbXBKJxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 04:53:19 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Data Caching Service
Date: Sun, 11 Feb 2007 14:53:12 +0530
Message-ID: <D566E8CF3538B54D95B925CB69CB4D2A01E8031B@inblr-exch1.eu.uis.unisys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Data Caching Service
Thread-Index: AcdBJ5uL70rxUgzzSeKZD9iR5SIK1gMlp0uw
From: "Satapathy, Soumendu Sekhar" <Soumendu.Satapathy@in.unisys.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Feb 2007 09:23:16.0002 (UTC) FILETIME=[429C6820:01C74DBE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



 

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
