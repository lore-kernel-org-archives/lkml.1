Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXBOHoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXBOHoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964982AbXBOHoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:44:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbXBOHoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:44:05 -0500
From: Neil Brown <neilb@suse.de>
To: "v j" <vj.linux@gmail.com>
Date: Thu, 15 Feb 2007 18:43:18 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17876.3862.261014.44098@notabene.brown>
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, "Dave Jones" <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: message from v j on Wednesday February 14
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	<9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	<20070215061149.GE15654@redhat.com>
	<9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	<20070214231143.11ff6b46.rdunlap@xenotime.net>
	<9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday February 14, vj.linux@gmail.com wrote:
> On 2/14/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > We seem to have different definitions of open and closed.
> 
> Open = 3rd party Linux drivers can be loaded. Closed = No third party
> Linux drivers can be loaded.

Loading a driver is not at issue.  Anyone may load a driver.

The issue is when you *distribute* a driver.
If that driver is a derived work or the Linux kernel, then you may
only distribute it under the terms of the GPLv2, which essentially
means that you make the source code available - under the GPLv2 - to
everyone you give the driver to.

How do you know if the driver is a derived work?
 Well, if it uses POSIX syscalls only, it isn't. (You can write USB
 drivers in user-space which do this).

 If it uses symbols exported with EXPORT_SYMBOL_GPL, then the author of the
 code which provides those symbols thinks that the driver is a derived
 work.

 If it uses EXPORT_SYMBOL symbols, then it is less clear what people
 believe, though there are certainly some who believe it will still
 be a derived work.

But of course the person who's opinion really counts is the judge.  So
you need to get legal advice.

NeilBrown
