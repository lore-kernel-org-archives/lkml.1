Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYBKBtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYBKBtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 20:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYBKBth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 20:49:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:7732 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYBKBtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 20:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=uy4GFP2Om37Rh1U7i3eTP9Gaoujo7+xozuYYJJJt0PydBSNClueXv+mUOrYL2ZFG55BGlGs0FUK7Zqy9irGjTvL0wW+0QYIzuaBDqNeljfi8DQ9vY/kd/8aWRDkObfDs2tr6WGbcPArfFHY1tivKbYG41j8sjRO4hAubIk4OGEk=
Message-ID: <86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com>
Date: Sun, 10 Feb 2008 17:49:34 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tony Camuso" <tcamuso@redhat.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <20080210204556.GG5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22679_25491773.1202694574960"
References: <20080129025615.GC20198@parisc-linux.org>
	 <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
	 <47AB299D.4000500@redhat.com>
	 <20080209124138.GA28967@parisc-linux.org>
	 <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
	 <20080210072116.GA12375@kroah.com>
	 <20080210145122.GC5299@parisc-linux.org>
	 <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
	 <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
	 <20080210204556.GG5299@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22679_25491773.1202694574960
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 10, 2008 12:45 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> On Sun, Feb 10, 2008 at 12:24:18PM -0800, Linus Torvalds wrote:
> > On Sun, 10 Feb 2008, Yinghai Lu wrote:
> > > >
> > > > I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
> > > > This patch is just cleanup (and takes care of some future concerns).
> > >
> > > your patch and Ivan's patch should be merged in one...
> >
> > I really don't care whether they get merges as one or separately, but I
> > think it should be merged _now_ (-rc1 is already delayed), and I'd like to
> > see the final versions of both. Does anybody have them in a final
> > agreed-upon format (preferably with that oddness in quirk_intel_irqbalance
> > also fixed?)
>
> I just looked at fixing that -- the reason seems to be that we don't
> actually have the struct pci_dev at that point.  I can fix it, but I
> think it's actually buggy.  I want to look at some chipset docs to
> confirm that though.
>
> I've attached the two patches that I believe are the ones we want.  We
> can (and should) fix quirk_intel_irqbalance separately.

Andrew,

those two patch just got into linus 2.6.25-rc1.

I assume that you will drop
gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch in
-mm.

please check some updated patches in -mm that could be affected. hope
it could save you some time

x86-validate-against-acpi-motherboard-resources.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch

YH

------=_Part_22679_25491773.1202694574960
Content-Type: application/x-bzip2; name=x.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcidfbs20
Content-Disposition: attachment; filename=x.tar.bz2

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
xdyRThQkKs1ygIA=
------=_Part_22679_25491773.1202694574960--
