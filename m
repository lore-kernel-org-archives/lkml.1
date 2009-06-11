Return-Path: <linux-kernel-owner+w=401wt.eu-S1761821AbZFKLAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761821AbZFKLAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZFKLAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:00:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34958 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZFKLAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:00:00 -0400
Date: Thu, 11 Jun 2009 11:59:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Macbook 4G only see 3G
Message-ID: <20090611105959.GA20801@srcf.ucam.org>
References: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com> <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com> <9b1675090906101943x10dff40ak32341383a516ae7c@mail.gmail.com> <4A3086B2.2010900@gmail.com> <9b1675090906102148m5634e652y34c101e28e4aab83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1675090906102148m5634e652y34c101e28e4aab83@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:48:00PM -0600, Trenton D. Adams wrote:
> On Wed, Jun 10, 2009 at 10:23 PM, Robert Hancock<hancockrwd@gmail.com> wrote:
> > Your dmesg shows your chiset is 945GM.
> > ==
> > intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory 16124kB
> > intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
> > intelfb: Video mode must be programmed at boot time.
> > ==
> > As far as I can found in English/Japanese forum, 945GM/PM? series can't handle
> > 4G memory. (Then, 64bit Vista can't handle it, either)
> 
> That's my graphics card though, not my motherboard chipset.  The
> chipset is ICH7.

ICH7 is the southbridge. 945 is the northbridge and includes the memory 
controller. It can only access 4GB of address space, which includes PCI 
and any other memory mapped resources. This means that it's not possible 
to use 4GB of RAM.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
