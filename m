Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXKMWFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXKMWFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759888AbXKMWFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:05:00 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:39675 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385AbXKMWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FeInrrb1SrDDUxpCe8odzAtCog2RYQ7S3907GqTq8aJu1bbw4CX3Uj3+3j0zV8dVEVKGKOKaGJIOYDXfSfY/te40EniJA0mpbRHqSAngu5l3F4OVFAhM2u4R+VW3PjdABYvOmEpExCWTtaZ9X1AS82lciFTl40Ufh/EOMk9jK2g=
Message-ID: <93d1fdd10711131404u4bdf1d08pb3f579e370c125f0@mail.gmail.com>
Date: Tue, 13 Nov 2007 17:04:57 -0500
From: "Ron Yorgason" <yorgasor@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071112194806.4cb9c688@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
	 <20071112194806.4cb9c688@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I received a response from Synchrotech, the supplier of one of my
cards.  He said that they were under NDA with their manufacturing
partner and couldn't offer the full specs.  However he could tell me
the specific bridge chip:

JMicron JMB368 PCIe to PATA controller

A quick google led me to their website where they advertised this
chipset as being supported by these OS's:

OS                            JMB368
Windows                            2K/XP/2003/Vista
BSD/FreeBSD                      FreeBSD 5.5 or above
BSD/OpenBSD                           OpenBSD 3.x
Linux/Redhat/Fedora                  Fedora Core 6
Linux/Suse                             Suse 10.1
Linux/Gentoo                     Gentoo 2006.1 liveCD
Linux/Ubuntu                          Ubuntu 6.10
Linux/RHEL                               RHEL 5
Linux/CENTOS                           CENTOS 5
Linux/Suse Enterprise              Suse Enterprise 10
Linux/Other Linux Distrbution   Kernel 2.6.18.2 or above
Unix/SCO OpenServer                SCO OpenServer 6
Unix/SCO UnixWare                SCO OpenServer 7.1.4
Unix/Solaris                           Solaris 10
NAS/FreeNAS                          FreeNAS 0.65
NAS/OpenFiler                        OpenFiler 2.3
NAS/Opene-NAS                       NAS/Opene-NAS
MAC OS X                            MAC OS 10.4.3*


It seems support for this chipset is already available in the kernel.
Is this enough information to enable DMA & PIO support for this
device?

--Ron

On Nov 12, 2007 2:48 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > the kernel), performance is pretty abysmal.  What would it take to get
> > proper DMA support?  Is it an architecture problem, in that this
> > doesn't use the normal IDE PCI driver?  Is it a lack of documentation
> > on card specs?  What can I do to help?
>
> Persuade Delkin to provide specifications either publically or under NDA
> (but allowing a GPL source code driver) with one of the ATA developers.
>
> For a fairly typical SFF style controller it shouldn't take long to
> produce a test driver.
>
> Alan
>
