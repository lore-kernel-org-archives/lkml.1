Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbZAVW71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbZAVW71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZAVW7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:59:19 -0500
Received: from animx.eu.org ([216.98.75.249]:39398 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZAVW7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:59:18 -0500
X-Greylist: delayed 1930 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 17:59:18 EST
Date: Thu, 22 Jan 2009 17:27:04 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: David Ronis <ronis@ronispc.chem.mcgill.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory not being reported
Message-ID: <20090122222704.GA27575@animx.eu.org>
Mail-Followup-To: David Ronis <ronis@ronispc.chem.mcgill.ca>,
	linux-kernel@vger.kernel.org
References: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ronis wrote:
> I'm running 2.6.28.1 on an i686 (slackware-12.1 for the most part) box.
> I recently added some extra memory, expanding from 2Gb to 4.  Everything
> works as expected except that not all of the memory seems to be seen.

I'm running on 2.6.24.3 right now which is irrelevent.  Is your system
x86_64 capable?  This specific machine is not.  It's an older dual xeon 533mhz
fsb.

> free returns:
> 
>              total       used       free     shared    buffers
> cached
> Mem:       3374860    2099504    1275356          0      86612
> 1032024
> -/+ buffers/cache:     980868    2393992
> Swap:       497972          0     497972

             total       used       free     shared    buffers     cached
Mem:       4019196    1342956    2676240          0     405712     223672
-/+ buffers/cache:     713572    3305624
Swap:            0          0          0


> On the other hand, user-space tools like lshw show the 4 1Gb DIMMS as
> does the BIOS configuration boot menu.

lshw IIRC uses dmi information to obtain that information.

> One suspicion is that the configure option CONFIG_HIGHMEM4G=y
> should be unset and the CONFIG_HIGHMEM64G  should be.

# grep HIGH .config
# CONFIG_HIGH_RES_TIMERS is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_HIGHMEM=y
# CONFIG_HIGHPTE is not set
# 

I see no reason not to use highmem 64gb  I've used it on several of my
systems, even ones that can't handle more than 2gb w/o problems.

One thing I have noticed (which is irrelevent to your question) is that I
see about 100mb less memory running a 64-bit kernel vs a 32-bit kernel on 2
systems (different brand of motherboard) and 4gb.  One was upgraded to 8gb;
32-bit shows about 8400000kb memory and running 64-bit shows about 8200000kb
memory.  Noone has answered my question as to why that is.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
