Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbZHVDr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbZHVDr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 23:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbZHVDrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 23:47:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933209AbZHVDrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 23:47:25 -0400
Date: Fri, 21 Aug 2009 20:47:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Gene Heskett <gene.heskett@verizon.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
In-Reply-To: <200908212309.31505.gene.heskett@verizon.net>
Message-ID: <alpine.LFD.2.01.0908212041130.3158@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <200908212309.31505.gene.heskett@verizon.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Aug 2009, Gene Heskett wrote:
> 
> From messages when I attempt to access the it87:

So what was the last kernel that worked ok for you?

> Aug 21 22:59:37 coyote kernel: [  572.507928] it87: Found IT8716F chip at 0x290, revision 1
> Aug 21 22:59:37 coyote kernel: [  572.507937] it87: in3 is VCC (+5V)
> Aug 21 22:59:37 coyote kernel: [  572.507939] it87: in7 is VCCH (+5V Stand-By)
> Aug 21 22:59:37 coyote kernel: [  572.508232] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__ [0x295-0x296]
> Aug 21 22:59:37 coyote kernel: [  572.508234] ACPI: Device needs an ACPI driver

There haven't been any changes to the it87 driver since 2.6.30, nor do I 
see any ACPI changes that would be relevant. Of course, if you used to 
build without any ACPI support at all, that region conflict wouldn't have 
shown up, so it _could_ be config-dependent, but that sounds unliklely 
too.

			Linus
