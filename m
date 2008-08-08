Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYHHCQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYHHCQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYHHCPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:15:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbYHHCPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:15:52 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interface	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <489BAA25.3030004@keyaccess.nl>
References: <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <20080805005132.GA3661@kroah.com>
	 <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>
	 <20080805170307.GB9639@kroah.com>
	 <1217962602.27684.144.camel@localhost.localdomain>
	 <20080805203007.GB27489@kroah.com>
	 <1218048597.27684.276.camel@localhost.localdomain>
	 <20080806210202.GA9413@mit.edu>
	 <1218058081.5837.49.camel@localhost.localdomain>
	 <20080806215244.GA21462@mit.edu>
	 <1218118603.5837.101.camel@localhost.localdomain>
	 <489BAA25.3030004@keyaccess.nl>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 22:15:38 -0400
Message-Id: <1218161738.5837.218.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 04:06 +0200, Rene Herman wrote:
> On 07-08-08 16:16, Eric Paris wrote:
> 
> > Absolutely, I think that our solution needs worry much less about an 
> > actively attacking root process than Windows.
> 
> Note by the way that this assumption is being actively undermined by all 
> those companies releasing software released as big executable blobs that 
> you just have to chmod +x and run; as root if you want them in /opt, or 
> /usr/local/bin, or ...

but you already say that said blob exists on disk?  Therefore by my most
basic of models it won't ever actually get to run since it will get
scanned right as you try to execute it and you will get EPERM instead of
a running evil process.  (all of that is assuming the userspace black
magic is useful, but I don't think that's really up for debate since we
have no way of knowing exactly what these closed source AV vendors
actually are doing....)

It looks in my mind that more and more the only real model that can even
attempt to be addressed is to make disks inhospitable to data which
might be intended to do ill to another machine.

Once the process is running we are talking about an IDS right?

> 
> Even when OpenOffice.org, IBM Lotus Symphony, RealPlayer, Flash, what 
> have you, might generally by themselves not be considered virusses both 
> the precedent they set and the opportunity for infecting systems by 
> offering those for re-download from elsewhere is worrying.
> 
> One of the more useful things the security crowd could do to keep the 
> above assumption valid would be working on a general "external software 
> installer" and getting all distributions to settle on it (which probably 
> needs a common divisor package and distro backends to feed it to the 
> native package manager).

maybe a good idea, but beyond my expertise or ability to push forward...

-Eric

