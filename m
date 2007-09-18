Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXIROu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXIROu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759004AbXIROuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:50:11 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52600 "EHLO
	caffeine.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbXIROuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:50:10 -0400
Date: Tue, 18 Sep 2007 10:50:09 -0400
To: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel-Quad on GA-P35-S3 motherboard with 4*2GB
Message-ID: <20070918145009.GH5386@csclub.uwaterloo.ca>
References: <46EA4B50.7040904@dgt.com.pl> <20070914131859.GC5386@csclub.uwaterloo.ca> <46EF77D8.3090808@dgt.com.pl> <20070918142047.GF5386@csclub.uwaterloo.ca> <46EFE23F.8090100@dgt.com.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EFE23F.8090100@dgt.com.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 04:35:43PM +0200, Wojciech Kromer wrote:
> Yes, it's a bit strange, but there should be a way to configure it in linux.
> I found only memmap option which does selection of regions, but not 
> remapping.

No it is entirely the BIOS's job to do that.  It would be very hard for
linux to safely change that.

> I have 64 bit compilation of course.

So in your case it would have been just fine with a simpler mapping.

> It's Intel-quad, so there are 4 CPUs.

Weird.  The message about the MTRR on all the CPUs not maching sound
like a strange bios bug.  Are you running the latest bios version?

> It's in prevoius mail:
> 
> # dmesg|grep BIOS-e820
> >BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> >BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> >BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> >BIOS-e820: 0000000000100000 - 000000009fee0000 (usable)
> >BIOS-e820: 000000009fee0000 - 000000009fee3000 (ACPI NVS)
> >BIOS-e820: 000000009fee3000 - 000000009fef0000 (ACPI data)
> >BIOS-e820: 000000009fef0000 - 000000009ff00000 (reserved)
> >BIOS-e820: 00000000c0000000 - 00000000c4000000 (reserved)
> >BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> >BIOS-e820: 0000000100000000 - 0000000260000000 (usable)

Looks to match the MTRR setup at least.  So how much ram does the kernel
actually want to use?

--
Len Sorensen
