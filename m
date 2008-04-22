Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbYDVXIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbYDVXIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbYDVXHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:07:41 -0400
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:57075 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762759AbYDVXHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:07:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Tue, 22 Apr 2008 16:07:13 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <480CEEA2.1040106@firstfloor.org> <20080422212548.GC6004@elf.ucw.cz>
In-Reply-To: <20080422212548.GC6004@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221607.13600.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2008 2:25 pm Pavel Machek wrote:
> > > Are you sure? I still boot DOS on very recent boxes, and they seem to
> > > work. How can PC-compatible machine require an APIC?
> >
> > The machine doesn't, but the drivers do. DOS likely doesn't use all
> > hardware.
>
> Should we be fixing drivers?
>
> Do drivers even know? I'd expect core code in arch/x86 to shield
> details of interrupt routing from them..

See my patch in the other sub-thread; I try to do just that.  MSI support 
should only depend on local APIC support, so even if we don't setup the 
IOAPIC(s) we should be able to leave MSI support enabled.

The patch works for me, but I haven't tried it on 32 bit yet.  Any comments 
Andi?

Thanks,
Jesse
