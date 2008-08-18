Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbYHRTHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbYHRTHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYHRTFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:05:01 -0400
Received: from mail.lang.hm ([64.81.33.126]:53200 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762761AbYHRTE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:04:59 -0400
Date: Mon, 18 Aug 2008 12:04:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
In-Reply-To: <1219085176.15566.100.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <20080818171500.78590801@lxorguk.ukuu.org.uk>  <1219080504.15566.65.camel@localhost.localdomain>  <20080818182556.13ced58f@lxorguk.ukuu.org.uk> 
 <1219082097.15566.82.camel@localhost.localdomain>  <20080818183540.GA5470@cs.cmu.edu> <1219085176.15566.100.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Eric Paris wrote:

> On Mon, 2008-08-18 at 14:35 -0400, Jan Harkes wrote:
>
>> The devil is in the details, and besides everyone trying to heap other
>> things on, one thing that keeps getting brought up, and seemingly keeps
>> getting ignored is the fact that there already is a perfectly reasonable
>> interface to pass file system events (open, close, read, write, etc) to
>> userspace applications in the form of FUSE which has already in some
>> ways solved issues wrt. subtle deadlocks that can happen when you bounce
>> from an in-kernel context to a userspace application.
>
> Can you help me write/prototype something that will work for every
> regular file anywhere on the system including the kernel binary
> in /boot, the glibc libraries in /lib/ld-linux.so, /sbin/ldconfig and
> every file on every USB stick you put into the machine?  When all of
> these are on separate partitions?  Every file under / needs to be
> exported to the scanner.  I'm very willing to believe fuse is the way to
> go for an HSM, but I don't see how to get every single file on the
> system through the FUSE based scanner.
>
> Yes propagation is an important use of file scanning (maybe the
> biggest), but we clearly can't secure every part of the border, and I
> don't know how to use fuse to do it all rather than just pieces and
> parts.
>
> You're absolutely right about this thread droning on.  But I've got code
> that solves the problems.  If someone else shows me better code rather
> than talk I'm all for it!

the issue is that the kernel developers are not that interested in 
creating one-off interfaces for anti-virus scanners. If the interfaces are 
more general and able to be used for a wider variety of problems they are 
much more interested in having them implemented.

unfortunantly you went off and developed a bunch of code before talking to 
people about what the appropriate interfaces would look like, (this is a 
common problem, see the 'how to participate in the kernel' document at 
http://ldn.linuxfoundation.org/book/how-participate-linux-community)

David Lang
