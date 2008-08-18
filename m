Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYHRP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYHRP7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYHRP7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:59:23 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:38050 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYHRP7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:59:22 -0400
In-Reply-To: <20080818163148.0ef3e383@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to a linux
 interface for on access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Mon, 18 Aug 2008 16:58:23 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 16:59:18,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 16:59:18,
	Serialize complete at 18/08/2008 16:59:18,
	S/MIME Sign failed at 18/08/2008 16:59:18: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 16:58:24,
	Serialize complete at 18/08/2008 16:58:24
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818155925.DC73A376469@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 18/08/2008 16:31:48:

> > Huh? I was never advocating re-scan after each modification and I even 

> > explicitly said it does not make sense for AV not only for performance 
but 
> > because it will be useless most of the time. I thought sending out 
> > modified notification on close makes sense because it is a natural 
point, 
> > unless someone is trying to subvert which is out of scope. Other have 
> > suggested time delay and lumping up.
> 
> You need a bit more than close I imagine, otherwise I can simply keep 
the
> file open forever. There are lots of cases where that would be natural
> behaviour - eg if I was to attack some kind of web forum and insert a
> windows worm into the forum which was database backed the file would
> probably never be closed. That seems to be one of the more common attack
> vectors nowdays.

Yes, I agree that modification notifications are needed in some cases.
 
> > Also, just to double-check, you don't think AV scanning would read the 

> > whole file on every write?
> 
> So you need the system to accumulate some kind of complete in memory set
> of 'dirty' range lists on all I/O ? That is going to have pretty bad
> performance impacts and serialization.

No, I was just saying scanning is pretty smart, it's not some brute force 
method of scan all data that is there. It has a file type detection and 
what and how to scan is determined by that. If a file does not resemble 
any file type I don't think it gets scanned. For example take couple of 
gigabytes of zeros and try to scan that with some products. I don't think 
they will try to read the whole file.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

