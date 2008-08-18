Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYHRKZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYHRKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYHRKZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:25:52 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:33581 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYHRKZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:25:51 -0400
In-Reply-To: <1219054440.10800.291.camel@twins>
To: Peter Zijlstra <peterz@infradead.org>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, douglas.leeder@sophos.com,
       hch@infradead.org, Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Mon, 18 Aug 2008 11:24:44 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 11:25:40,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 11:25:40,
	Serialize complete at 18/08/2008 11:25:40,
	S/MIME Sign failed at 18/08/2008 11:25:40: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 11:24:49,
	Serialize complete at 18/08/2008 11:24:49
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818102552.C71C42FE81F@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote on 18/08/2008 11:14:00:

> On Mon, 2008-08-18 at 12:09 +0200, Helge Hafting wrote:
> > 
> > Scanning on open should be a last resort. Scan in advance when you 
can.
> > Of course, removable media cannot be scanned until it is inserted and 
> > mounted,
> > that is obvious. The scanning can start as soon as the filesystem is 
> > mounted though,
> > there is no reason to wait until users try to access something.
> > 
> > A CD inserted into a CD-server may not necessarily be needed 
immediately, so
> > scanning in advance will help here too. The user inserting a CD in a 
home
> > computer may start to use stuff right away, or perhaps he spends
> > some time reading the docs before a complicated install. Sill room for 
some
> > scanning in advance, which also may end up with the nice effect of 
> > caching the CD.
> 
> Hmm, then there is the issue that an active scanner will avoid me from
> removing the media again. Most annoysome when the machine won't promptly
> give back the disk.
> 
> Imagine me browsing through a stack of unmarked dvd-rw media trying to
> find the one with the right file on it, but having to wait every time
> for the whole media to get scanned..
> 
> Not a nice picture.

I agree. And not only that but also the fact that most of the time I would 
not want mount to trigger a background scan of everything because not all 
might be accessed later. Therefore it would be just wasting resources and 
ruining user experience. This argument is flawed in a way that is 
unsolvable in the same way normal preload to page cache is unsolvable 
because it is impossible to predict the usage pattern.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

