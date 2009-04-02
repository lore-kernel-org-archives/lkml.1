Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZDBAjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZDBAjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZDBAjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:39:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52692 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbZDBAjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:39:23 -0400
Message-ID: <49D4092D.5050503@garzik.org>
Date: Wed, 01 Apr 2009 20:39:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Avishay Traeger <avishay@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
References: <49C1331D.1080805@panasas.com> <49D332A0.5080107@garzik.org> <49D34E33.5060700@panasas.com>
In-Reply-To: <49D34E33.5060700@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.6 (---)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-3.6 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 04/01/2009 12:23 PM, Jeff Garzik wrote:
>> Boaz Harrosh wrote:
>>> If anyone wants to actually run this code and test it
>>> then please start reading at:
>>>     http://open-osd.org
>>> You will need to checkout the out-of-tree git (below) for the user-mode utilities.
>>> Also the exofs.txt file in patch 7/8 should help
>>
>> hum...  trying to play with this.  If you want exofs to go upstream, I 
>> think you should have a release tarball containing the user-mode utils 
>> posted somewhere.  Would make life a lot easier, both on early adopters 
>> and also on distribution packagers.
>>
>> 	Jeff
> 
> You are absolutely right, once 2.6.30 will be out there will not be a need
> to compile Kernel modules.
> 
> About the binary package. I must admit I'm a total novice. What do I need to do?

All you need on your end is a sane setup for installation, including 
building of shared libraries and installing necessary headers for 
userland programs.

Each individual distribution can easily package your exofs-utils into a 
deb or RPM.

Some of my projects have to do this.  Here is one way, the highly 
standardized GNU autotools.

Take a look at autogen.sh, configure.ac, Makefile.am, 
include/Makefile.am and lib/Makefile.am from 
git://git.kernel.org/pub/scm/daemon/distsrv/chunkd.git

That demonstrates how to handle building and installing a shared 
library, header files and programs.

A lot of people dislike GNU autotools, but it's main benefit here is 
that Debian/Red Hat/Novell/Canonical/etc. are well-versed in creating 
.deb or .rpm from GNU autotools builds.  It makes integration into a 
Linux distribution much easier.


> BTW:
>   Source tar balls are available from the gitweb GUI by pressing on the
>   "snapshot" link next to any commit. I should link to it from the WiKi

Oh yeah, I forgot about that.

	Jeff



