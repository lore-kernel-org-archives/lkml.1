Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXF3Odj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXF3Odj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXF3Od3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:33:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:43764 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbXF3Od2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:33:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,480,1175497200"; 
   d="scan'208";a="262931476"
Message-ID: <468669AF.2030401@intel.com>
Date: Sat, 30 Jun 2007 07:33:19 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Aloni <da-x@monatomic.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
References: <20070630023451.GA21593@localdomain>	<4685C549.3020602@intel.com> <20070630025425.59cbc299.akpm@linux-foundation.org>
In-Reply-To: <20070630025425.59cbc299.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 29 Jun 2007 19:51:53 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> 
>>> Some extensions to the popular E-Mail clients might be needed 
>>> here. Also, a bot reading LKML would automatically send links 
>>> about posted patches to the other mailing lists whenever 
>>> someone forgets to add a CC.
>>>
>>> Any comments?
>> an easier way to implement this is to add an extra field in the MAINTAINERS 
>> file, something like below. All the contact info would stay the same, closely 
>> where applicable and it would allow you to also specify specific files as well.
> 
> We already have that information in git.  Parse the git changelogs of the
> affected files, find out who works on them.
> 
> Not that it'll help much, given the amnount of stuff which gets
> mysteriously ignored even when the correct people are cc'ed...
> 
> (For extra giggles we could parse emailed oops and bug reports and add the
> appropriate cc's there too.  Harder.)

well, I'm more thinking of the advertisement value of having some sort of 
pointer in the MAINTAINERS file to the exact location of a certain subsystem. 
Quite often I find myself searching somewhere in /drivers/ only to find out that 
the stuff I need is in asm/arch or elsewhere. E.g. alsa is a driver but lives in 
/sound/. Having a voluntary field (usable for other purposes) in the MAINTAINERS 
field seems awfully appropriate in that place and very low impact.

git does have that info, except for the fact that quite often others touch the 
same subsystem much more than the maintainer (pci, net, etc)...

Auke
