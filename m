Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbXBZUwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbXBZUwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161025AbXBZUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:52:13 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:48197 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbXBZUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:52:13 -0500
In-Reply-To: <1172505099.11949.13.camel@localhost.localdomain>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> <1172448057.3971.9.camel@shinybook.infradead.org> <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org> <1172452660.3971.33.camel@shinybook.infradead.org> <1172505099.11949.13.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <21943DC0-5FA7-4769-9EFD-6A0461C5664A@kernel.crashing.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Make sure we populate the initroot filesystem late enough
Date: Mon, 26 Feb 2007 14:51:00 -0600
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 26, 2007, at 9:51 AM, Benjamin Herrenschmidt wrote:

> On Sun, 2007-02-25 at 20:17 -0500, David Woodhouse wrote:
>> On Sun, 2007-02-25 at 16:24 -0800, Linus Torvalds wrote:
>>> Hmm. No, I don't think that should be a problem. free_initmem() only
>>> happens at the very, after do_basic_setup() has been run, which
>>> includes all the initcall stuff.
>>
>> I'm inclined to agree that it _shouldn't_ be a problem. Nevertheless,
>> even this hack seems sufficient to 'fix' it:
>
> Could be a powerpc specific bug in initrd handling... I'm still
> traveling so I can't really look at it right now, but I wouldn't be
> surprised if some of that code did indeed bitrot.
>
> Ben.

Could there be some issue with initrd getting reserved properly via  
prom_init.c.  I know we make sure there are memreserve's in the fdt  
for initrd on embedded ppc.

- k
