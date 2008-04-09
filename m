Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYDIIhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYDIIhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYDIIhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:37:06 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:43606 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYDIIhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:37:05 -0400
Date: Wed, 9 Apr 2008 11:37:00 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, mingo@elte.hu,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409083700.GU3700@mea-ext.zmailer.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqyro3rc.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 10:01:59AM +0200, Andi Kleen wrote:
> "Zhao Forrest" <forrest.zhao@gmail.com> writes:
> >
> > As we can see from above information that the physical memory in system
> > is 32768MB(32GB). However OS is only using about
> > (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
> > linux kernel can't use the physical memory remapped
> > from (4G-512M, 4G) to (32G, 32G+512M)?
> 
> The linux kernel can only use the memory passed to it by the BIOS.
> Sometimes they need special BIOS setup options to enable remapping. If
> there are no such options and you can't upgrade it you're out of luck
> 
> I would suggest you contact your system vendor.

I second that.   On my home machine I have early ASUS  AMD x64 board from
a few years ago.  For it I did buy CPU with this memory mapping hardware
inside, but the BIOS did not support it correctly until a year or two latter,
thus I was not able to use all of 4 GB of memory I had installed there.
There was support in BIOS from start, but it did things wrong.

Looks like BIOS-writers don't really have test environments for extreme
far edges of system configurations - "yes, we support --> sales $$$".
And once product ships, rare extreme users rarely report anything back.


Long time ago (very long ?) when 386 machines got more than 1 MB memory,
there was (and probably still is) a hole in low 1 MB address space, because
of VGA display memory space and BIOS ROM.  With 1-32 MB of memory in system,
the hardware makers created inventive ways to map the masked 384 kB to
the top of the address space.

I make a prediction that the same way as that old VGA/BIOS mapping, also
the address space masked by PCI window will eventually simply be ignored.
.. or be used in automatic memory chip internal "faulty block mapper".
That will start to happen in about 10 years.  (Perhaps also PCIe starts
to disappear around that time, like PCI does now.)

> -Andi

/Matti Aarnio
