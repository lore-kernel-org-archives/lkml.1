Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0BCMay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:30:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:34241 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0BCMaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,397,1262592000"; 
   d="scan'208";a="769718102"
Date: Wed, 3 Feb 2010 13:32:19 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] mfd: Add support for the timberdale FPGA.
Message-ID: <20100203123218.GE3460@sortiz.org>
References: <4B694463.6050306@pelagicore.com>
 <20100203104448.GB3460@sortiz.org>
 <4B6955AE.1090709@pelagicore.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B6955AE.1090709@pelagicore.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:53:34AM +0000, Richard Röjfors wrote:
> On 02/03/2010 11:45 AM, Samuel Ortiz wrote:
> > Hi Richard,
> >
> > On Wed, Feb 03, 2010 at 09:39:47AM +0000, Richard Röjfors wrote:
> >> The timberdale FPGA is found on the Intel in-Vehicle Infotainment reference board
> >> russelville.
> >>
> >> The driver is a PCI driver which chunks up the I/O memory and distributes interrupts
> >> to a number of platform devices for each IP inside the FPGA.
> >>
> >> Signed-off-by: Richard Röjfors<richard.rojfors@pelagicore.com>
> > The patch looks good to me, I have a couple of minor comments though:
> >
> > - Please replace most of your printk with dev_dbg/err()
> 
> Agreed.
> 
> > - Please fix your checkpatch output:
> > total: 255 errors, 18 warnings, 822 lines checked
> 
> Sweet, the mail client changed all tabs to spaces when resending the patch.
Actually, your first patch to the linux-media ml also had tabs changed into
spaces.

Cheers,
Samuel.

 
> --Richard
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

