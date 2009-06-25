Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZFYRJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZFYRJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZFYRJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:09:11 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44632 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZFYRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:09:10 -0400
Date: Fri, 26 Jun 2009 02:08:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Florian Fainelli <florian@openwrt.org>,
       Mike Rapoport <mike@compulab.co.il>, Alain Knaff <alain@knaff.lu>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
Message-ID: <20090625170806.GA22326@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michael Opdenacker <michael-lists@free-electrons.com>,
	Florian Fainelli <florian@openwrt.org>,
	Mike Rapoport <mike@compulab.co.il>, Alain Knaff <alain@knaff.lu>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-embedded mailing list <linux-embedded@vger.kernel.org>
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il> <200906251104.02830.florian@openwrt.org> <4A4396CB.9000703@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4396CB.9000703@free-electrons.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 05:24:59PM +0200, Michael Opdenacker wrote:
> On 06/25/2009 11:04 AM, Florian Fainelli wrote:
> > Le Thursday 25 June 2009 10:56:45 Mike Rapoport, vous avez ?crit :
> >> I'm not sure what exactly do you mean by "test bzip2 and lzma compression
> >> on ARM", but if you refer to internal initramfs compression, I can tell
> >> that I've used lzma compression on PXA270 and it works fine.
> >>     
> >
> > I think Michael refers to the lzma decompressor which allows you to use a 
> > lzma-compressed kernel as a (b)zImage with its architecture specific 
> > decompressor piggy-backed in the (b)zImage.
> >
> > Such thing would also be very useful on MIPS and PowerPC as well.
> >   
> Yes, that's what I meant: using a bzip2 or lzma compressed kernel. I
> would like to know the boot time impact on an ARM board.
> 
> If I don't get any answer from Alain in the next days, I will propose a
> patch update for ARM.
> 
It's possible to use this generically now, yes. Anything building uImages
today can basically wire it up in a similar fashion to how blackfin has
and support it out of the box.
