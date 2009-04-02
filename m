Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbZDBMv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbZDBMv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZDBMvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:51:45 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:25911 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbZDBMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:51:44 -0400
Message-ID: <49D4B461.1070603@panasas.com>
Date: Thu, 02 Apr 2009 15:49:37 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Avishay Traeger <avishay@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
References: <49C1331D.1080805@panasas.com> <49D332A0.5080107@garzik.org> <49D34E33.5060700@panasas.com> <49D4092D.5050503@garzik.org>
In-Reply-To: <49D4092D.5050503@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 12:51:41.0392 (UTC) FILETIME=[C5063D00:01C9B391]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2009 03:39 AM, Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> On 04/01/2009 12:23 PM, Jeff Garzik wrote:
>>> Boaz Harrosh wrote:
>>>> If anyone wants to actually run this code and test it
>>>> then please start reading at:
>>>>     http://open-osd.org
>>>> You will need to checkout the out-of-tree git (below) for the user-mode utilities.
>>>> Also the exofs.txt file in patch 7/8 should help
>>> hum...  trying to play with this.  If you want exofs to go upstream, I 
>>> think you should have a release tarball containing the user-mode utils 
>>> posted somewhere.  Would make life a lot easier, both on early adopters 
>>> and also on distribution packagers.
>>>
>>> 	Jeff
>> You are absolutely right, once 2.6.30 will be out there will not be a need
>> to compile Kernel modules.
>>
>> About the binary package. I must admit I'm a total novice. What do I need to do?
> 
> All you need on your end is a sane setup for installation, including 
> building of shared libraries and installing necessary headers for 
> userland programs.
> 
> Each individual distribution can easily package your exofs-utils into a 
> deb or RPM.
> 
> Some of my projects have to do this.  Here is one way, the highly 
> standardized GNU autotools.
> 
> Take a look at autogen.sh, configure.ac, Makefile.am, 
> include/Makefile.am and lib/Makefile.am from 
> git://git.kernel.org/pub/scm/daemon/distsrv/chunkd.git
> 
> That demonstrates how to handle building and installing a shared 
> library, header files and programs.
> 
> A lot of people dislike GNU autotools, but it's main benefit here is 
> that Debian/Red Hat/Novell/Canonical/etc. are well-versed in creating 
> .deb or .rpm from GNU autotools builds.  It makes integration into a 
> Linux distribution much easier.
> 

This is precious information for me, I'll have a look and copy above procedure
for open-osd, thanks, Next beer is on me.

> 
>> BTW:
>>   Source tar balls are available from the gitweb GUI by pressing on the
>>   "snapshot" link next to any commit. I should link to it from the WiKi
> 
> Oh yeah, I forgot about that.
> 
> 	Jeff
> 

Thank you
Boaz
