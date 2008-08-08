Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYHHC4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYHHC4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYHHC4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:56:17 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:33095 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYHHC4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:56:16 -0400
Message-ID: <489BB5BE.20602@keyaccess.nl>
Date: Fri, 08 Aug 2008 04:55:58 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux	interface	for
 on access scanning
References: <20080804223249.GA10517@kroah.com>	 <1217896374.27684.53.camel@localhost.localdomain>	 <20080805005132.GA3661@kroah.com>	 <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>	 <20080805170307.GB9639@kroah.com>	 <1217962602.27684.144.camel@localhost.localdomain>	 <20080805203007.GB27489@kroah.com>	 <1218048597.27684.276.camel@localhost.localdomain>	 <20080806210202.GA9413@mit.edu>	 <1218058081.5837.49.camel@localhost.localdomain>	 <20080806215244.GA21462@mit.edu>	 <1218118603.5837.101.camel@localhost.localdomain>	 <489BAA25.3030004@keyaccess.nl> <1218161738.5837.218.camel@localhost.localdomain>
In-Reply-To: <1218161738.5837.218.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-08-08 04:15, Eric Paris wrote:

> On Fri, 2008-08-08 at 04:06 +0200, Rene Herman wrote:
>> On 07-08-08 16:16, Eric Paris wrote:
>>
>>> Absolutely, I think that our solution needs worry much less about an 
>>> actively attacking root process than Windows.
>> Note by the way that this assumption is being actively undermined by all 
>> those companies releasing software released as big executable blobs that 
>> you just have to chmod +x and run; as root if you want them in /opt, or 
>> /usr/local/bin, or ...
> 
> but you already say that said blob exists on disk?  Therefore by my most
> basic of models it won't ever actually get to run since it will get
> scanned right as you try to execute it and you will get EPERM instead of
> a running evil process.  (all of that is assuming the userspace black
> magic is useful, but I don't think that's really up for debate since we
> have no way of knowing exactly what these closed source AV vendors
> actually are doing....)
> 
> It looks in my mind that more and more the only real model that can even
> attempt to be addressed is to make disks inhospitable to data which
> might be intended to do ill to another machine.
> 
> Once the process is running we are talking about an IDS right?

Once the process is running we are talking about having lost.

Note, I did not follow this thread (closely) ...

Thing is just -- just wait for how long it takes said clueless user you 
are so vigorously protecting to disable that which brings about your 
model the first time if interferes with him running a cracked copy of an 
expensive yet popular program, playing a game, installing a wiggling 
nudies screensaver, ...

The difference here is just that Linux systems are particularly bad at 
those tasks to begin with which in nice circular motions keeps those 
clueless users away, obviating the need to protect ourselves from them. 
If this stuff is to be discussed in a context as if Linux were relevant 
on the desktop though, I believe it's rather unproductive to expect a 
fundamental difference with Windows in this respect.

Fine though if you wouldn't insist on that context. As said, wasn't 
following along really.

>> Even when OpenOffice.org, IBM Lotus Symphony, RealPlayer, Flash, what 
>> have you, might generally by themselves not be considered virusses both 
>> the precedent they set and the opportunity for infecting systems by 
>> offering those for re-download from elsewhere is worrying.
>>
>> One of the more useful things the security crowd could do to keep the 
>> above assumption valid would be working on a general "external software 
>> installer" and getting all distributions to settle on it (which probably 
>> needs a common divisor package and distro backends to feed it to the 
>> native package manager).
> 
> maybe a good idea, but beyond my expertise or ability to push forward...

I'll leave it in just in case it spurs someone :)

Rene.
