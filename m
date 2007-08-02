Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXHBMfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXHBMfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXHBMfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:35:22 -0400
Received: from ns1.suse.de ([195.135.220.2]:36273 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbXHBMfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:35:21 -0400
Subject: Re: 2.6.22 regression: thermal trip points
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian =?ISO-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <20070802121556.GA30114@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de>
	 <1186047747.18821.450.camel@queen.suse.de>
	 <200708021145.09377.adrian@suse.de>
	 <1186048701.18821.459.camel@queen.suse.de>
	 <20070802120221.5474e732@the-village.bc.nu>
	 <20070802111327.GA29002@srcf.ucam.org>
	 <20070802125947.4a1ff933@the-village.bc.nu>
	 <20070802115743.GB29735@srcf.ucam.org>
	 <1186056386.18821.497.camel@queen.suse.de>
	 <20070802121556.GA30114@srcf.ucam.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 14:35:18 +0200
Message-Id: <1186058118.18821.516.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 13:15 +0100, Matthew Garrett wrote:
> On Thu, Aug 02, 2007 at 02:06:26PM +0200, Thomas Renninger wrote:
> > On Thu, 2007-08-02 at 12:57 +0100, Matthew Garrett wrote:
> > > On Thu, Aug 02, 2007 at 12:59:47PM +0100, Alan Cox wrote:
> > > > Windows as I understand it has vendor mechanisms to allow the bits
> > > > shipped with the OS to override/ignore just about everything trip points
> > > > included. Lots of hardware that requires fixups in Linux and just works
> > > > in Windows is not Linux bugs but Windows magic .inf files and other
> > > > registry gunge done by the machine vendor. We see this in ATA, in power
> > > > management and elsewhere.
> > > 
> > > I've seen no evidence that this happens with thermal trip points.
> > 
> > WMI needed for fan control -- FSC Amilo M3438G
> > http://bugzilla.kernel.org/show_bug.cgi?id=5670
> 
> That machine has no active thermal trip points, so I'm not sure how it's 
> relevant here.
>From above: "Windows as I understand it has vendor mechanisms to..."
Maybe thermal trip points are not influenced here, it's at least about
thermal management and another prove that we cannot just try to copy
Windows behavior, but need to provide workarounds wherever possible.

   Thomas

> By the sounds of the bug log, I suspect Linux just runs 
> slightly hotter on the machine than Windows does - especially since the 
> user isn't running the closed nvidia driver, so there's nothing to carry 
> out any power management on the GPU.

