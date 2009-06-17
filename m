Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbZFQUGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbZFQUGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbZFQUGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:06:40 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:64868 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbZFQUGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <fa686aa40906171115m3e3faab2r63814ea8013056d0@mail.gmail.com>
References: <20090605182651.24094.36577.sendpatchset@elm3a191.beaverton.ibm.com> 
	<200906091738.58154.david-b@pacbell.net> <1244799348.5234.13.camel@subratamodak.linux.ibm.com> 
	<1245048679.5239.8.camel@subratamodak.linux.ibm.com> <1245243186.4870.5.camel@subratamodak.linux.ibm.com> 
	<fa686aa40906171115m3e3faab2r63814ea8013056d0@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 17 Jun 2009 14:06:21 -0600
Message-ID: <fa686aa40906171306l3cfe5459j65f11b100f23bfd@mail.gmail.com>
Subject: Re: [BUILD FAILURE 02/04] Next June 04:PPC64 randconfig 
	[drivers/usb/host/ohci-hcd.o]
To: subrata@linux.vnet.ibm.com
Cc: David Brownell <david-b@pacbell.net>, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux-Next <linux-next@vger.kernel.org>, Jon Smirl <jonsmirl@gmail.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel@wantstofly.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 12:15 PM, Grant Likely<grant.likely@secretlab.ca> wrote:
> On Wed, Jun 17, 2009 at 6:53 AM, Subrata
> Modak<subrata@linux.vnet.ibm.com> wrote:
>> On Mon, 2009-06-15 at 12:21 +0530, Subrata Modak wrote:
>>> On Fri, 2009-06-12 at 15:05 +0530, Subrata Modak wrote:
>>> > On Tue, 2009-06-09 at 17:38 -0700, David Brownell wrote:
>>> > > On Friday 05 June 2009, Subrata Modak wrote:
>>> > > > Correct, it fixes the issue. However, since few changes might have gone
>>> > > > to the Kconfig, the patch does not apply cleanly. Below is the patch, just
>>> > > > a retake of the earlier one, but on the latest code.
>>> > >
>>> > > And it got mangled a bit along the way.  Plus, the original one
>>> > > goofed up Kconfig dependency displays ... both issues fixed in
>>> > > this version, against current mainline GIT.
>>> > >
>>> > > If someone can verify all four PPC/OF/OHCI configs build on
>>> > > on PPC64, I'm OK with it.
>>> > >
>>> > > - Dave
>>> >
>>> > Dave,
>>> >
>>> > Sorry for being late. The patch fixes the issue on the latest git for
>>> > PPC64. Infact, the whole drivers/usb/host/ builds just fine:
>>> >
>>> > linux-2.6 # make drivers/usb/host/
>>> >   CHK     include/linux/version.h
>>> >   CHK     include/linux/utsrelease.h
>>> >   SYMLINK include/asm -> include/asm-powerpc
>>> >   CALL    scripts/checksyscalls.sh
>>> >   CC      drivers/usb/host/ohci-hcd.o
>>> >   CC      drivers/usb/host/pci-quirks.o
>>> >   CC      drivers/usb/host/uhci-hcd.o
>>> >   LD      drivers/usb/host/built-in.o
>>> >   CC [M]  drivers/usb/host/isp116x-hcd.o
>>> >   CC [M]  drivers/usb/host/u132-hcd.o
>>> >
>>> > You can check in the patch now.
>>>
>>> Dave,
>>>
>>> Have you checked in this patch ? Or, does it require some more
>>> modification/updates from somebody´s side ?
>>>
>>
>> Dave,
>>
>> Would you consider checking in this patch ?
>
> Hold off please; give me a couple of hours to investigate.

Never mind; I replied to the wrong email.  Please ignore my comments.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
