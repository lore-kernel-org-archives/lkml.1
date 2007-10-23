Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbXJWQFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbXJWQFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJWQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:04:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54097 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752740AbXJWQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:04:51 -0400
Date: Tue, 23 Oct 2007 18:05:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Greg KH <greg@kroah.com>, Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Crispin Cowan <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071023160520.GV30533@stusta.de>
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com> <20071022035954.GA30991@kroah.com> <471CE238.5040107@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <471CE238.5040107@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:47:36PM +0200, Avi Kivity wrote:
> Greg KH wrote:
>> On Sun, Oct 21, 2007 at 07:24:42PM -0700, Thomas Fricaccia wrote:
>>   
>>> Yes, I think Crispin has succinctly summed it up:  irrevocably closing
>>> the LSM prevents commercial customers from using security modules other
>>> than that provided by their Linux distributor.
>>>     
>>
>> Any "customer" using a security model other than provided by their Linux
>> distributor instantly voided all support from that distro by doing that.
>>
>> So, since the support is gone, they can easily build their own kernels,
>> with their own LSM interfaces, and get the exact same lack of support :)
>
> Running a vendor kernel has the advantage of reusing all the QA work that 
> has gone into that kernel.  It is very different from running 2.6.24-rc1 
> (or 2.6.22.x).  Hence projects like centos: you don't get any support, but 
> the likelihood of actually requiring support is lower than running some 
> random kernel.

You can also get the QA work by building your own kernel from vendor 
kernel sources.

E.g. the Debian distribution ships a package linux-source-2.6.18 that 
contains a linux-source-2.6.18.tar.bz2 with the patched 2.6.18 kernel 
sources Debian uses for building its kernels.

> [but I agree that someone who has somehow determined that they need a 
> specific LSM will probably have determined that they need vendor support as 
> well]

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

