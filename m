Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYAIBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYAIBlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYAIBl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:41:28 -0500
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:59030 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753046AbYAIBl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:41:27 -0500
X-Greylist: delayed 11613 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 20:41:27 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
Date: Tue, 8 Jan 2008 11:02:12 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andi Kleen <andi@firstfloor.org>, Robert Hancock <hancockr@shaw.ca>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, akpm@osdl.org,
       rajesh.shah@intel.com, greg@kroah.com
References: <20080107224757.GA2336@basil.nowhere.org> <20080108161409.GB31504@one.firstfloor.org> <20080108162759.GG32273@elte.hu>
In-Reply-To: <20080108162759.GG32273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081102.14168.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 69.89.22.128 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 08, 2008 8:27 Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> > > > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/
> > > >2.6.24-rc6/2.6.24-rc6-mm1/broken-out/pci-disable-decoding-during
> > > >-sizing-of-bars.patch
> > > >
> > > > Without this change a bunch of machines fail to boot even
> > > > without the MCFG change (since their MCFG was E820 reserved and
> > > > so the old validation check passed).
> > >
> > > Andi, can you confirm that your box boots fine with that patch
> > > applied?
> >
> > Yes it does.
>
> thanks for testing it. (and thanks for finding & reporting the
> problem) I've added that patch to x86.git, right before:
>
>   Subject: x86: validate against ACPI motherboard resources
>
> this should be the only dependency AFAICS.

Yeah, that should work afaik, thanks for sorting this out.

Jesse
