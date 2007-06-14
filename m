Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXFNVTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXFNVTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXFNVSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:18:53 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:35781 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752113AbXFNVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:18:52 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Thu, 14 Jun 2007 14:18:41 -0700
User-Agent: KMail/1.9.6
Cc: Pim Zandbergen <P.Zandbergen@macroscoop.nl>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706071530.51552.jesse.barnes@intel.com> <4671992D.7060400@macroscoop.nl> <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706141418.42082.jbarnes@virtuousgeek.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 14, 2007 1:26:07 Justin Piszcz wrote:
> On Thu, 14 Jun 2007, Pim Zandbergen wrote:
> > Thanks for this patch. I was having the exact same symptoms as
> > Justin Piszcz, on a different, but similar motherboard:
> >
> > Motherboard: GigaByte GA-G33-DS3R
> > BIOS rev: F2
> > Chipset: Intel G33
> > Memory: 8GB
> > Distro: Fedora 7 x86_64
> > Kernel: kernel-2.6.21-1.3194.fc7
> >
> > Building vanilla 2.6.22-rc4 with your patch solved the problem.
> >
> > I'm now seeing this in the syslog
> >
> > ***************
> > **** WARNING: likely BIOS bug
> > **** MTRRs don't cover all of memory, trimmed 196608 pages
> > ***************
> >
> > leaving me 7416672 kB of usable memory.
> >
> > If there's any way I can help with more info or testing,
> > then let me know.
> >
> > Thanks,
> > Pim

Thanks for testing, Pim.  Glad it works for you.  Keep an eye out for 
BIOS upgrades, the next version might fix it.

> That's strange, I guess different chipsets 'chew' up different
> amounts of memory OR you have your DVT(?) (video-card
> memory/aperature) set to 256MB? I have mine set to 128MB, in top:
>
> Mem:   8039576k total,  6187304k used,  1852272k free,      696k
> buffers
>
> What type of memory are you using and what is your DVT set to?

Different BIOSes will map things differently, so I'd expect differences 
in the "trimmmed xxx pages" message across machines.  But yeah, BIOS 
config options can also affect things, in particular I've heard that 
the fan control options change MTRR setup significantly.

Jesse
