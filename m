Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXEGMAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXEGMAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbXEGMAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:00:06 -0400
Received: from rex.snapgear.com ([203.143.235.140]:35257 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933387AbXEGMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:00:04 -0400
Message-ID: <463F14BA.3030304@snapgear.com>
Date: Mon, 07 May 2007 21:59:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
References: <46382055.8030203@snapgear.com> <200705030735.36879.rgetz@blackfin.uclinux.org> <4639E40D.6030809@snapgear.com> <200705041212.03614.rgetz@blackfin.uclinux.org> <20070506114453.GB29643@flint.arm.linux.org.uk>
In-Reply-To: <20070506114453.GB29643@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Fri, May 04, 2007 at 12:12:03PM -0400, Robin Getz wrote:
>>>> Depending on how TASK_SIZE is defined - it looks like everyone else
>>>> forces it to end of memory, except 68k[nommu].
>>>>
>>>> asm-arm/memory.h:#define TASK_SIZE              (CONFIG_DRAM_SIZE)
>>> That is one way to handle it. Have you followed all the other
>>> uses of TASK_SIZE and verified it is not a problem?
>> No, I assumed that Russell/David were smarter than we were, and that doing so 
>> would not be a problem :)
> 
> Don't look at me - the above came from Hyok, and I just assumed that it
> was correct without really understanding it.
> 
> I've noticed though that Hyok's gone rather quiet, so I'm not sure
> whether we'll ever get ARM uclinux integration complete.

We can do this without Hyok.

The patches I sent to arm-linux-kernel last week fill all the gaps
that I see. I'll be reworking that over the coming weeks to try and
get something that is acceptable to all, so we can get this done.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
