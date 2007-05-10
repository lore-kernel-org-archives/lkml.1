Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbXEJPyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbXEJPyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXEJPyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:54:37 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4132 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbXEJPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:54:36 -0400
Message-ID: <46434041.7020903@shadowen.org>
Date: Thu, 10 May 2007 16:54:41 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: paulus@samba.org, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] update sysfs kset initialisation in PPC64 DLPAR IO	driver
References: <464322F3.3010808@shadowen.org> <2c705c055fcd12202673ee8a3056153b@pinky> <20070510141221.GA26709@suse.de>
In-Reply-To: <20070510141221.GA26709@suse.de>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, May 10, 2007 at 03:00:50PM +0100, Andy Whitcroft wrote:
>> Move the rpadlpar device from "struct subsystem" to "struct kset"
>> following the changes in sysfs.
>>
>> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
>> ---
>>
>> 	Ok, this patch seems to sort out the compile problem
>> 	here and indeed boots and runs kernbench.  Perhaps
>> 	you could confirm this is sufficient.
> 
> As per the discussion on the pci hotplug list, no, this doesn't seem to
> fix the problem.  The developers there are looking into it.  If you can
> test out patches for this, I'm sure the people there would appreciate
> the help.

Sure anything they have for testing, send them to me ...

-apw
