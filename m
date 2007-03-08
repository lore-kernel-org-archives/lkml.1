Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXCHQFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXCHQFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXCHQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:05:23 -0500
Received: from mga06.intel.com ([134.134.136.21]:21329 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752439AbXCHQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:05:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,264,1170662400"; 
   d="scan'208"; a="206043604:sNHT21783615"
Date: Thu, 8 Mar 2007 08:45:29 -0800
From: "Lombard, David N" <dnlombar@ichips.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, rjw@sisk.pl, ebiederm@xmission.com,
       hpa@zytor.com, magnus.damm@gmail.com, akpm@linux-foundation.org,
       Reloc Kernel List <fastboot@lists.osdl.org>, ak@suse.de,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [Fastboot] [PATCH 11/20] x86_64: wakeup.S misc cleanups
Message-ID: <20070308164529.GA5308@nlxdcldnl2.cl.intel.com>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Vivek Goyal <vgoyal@in.ibm.com>, rjw@sisk.pl, ebiederm@xmission.com,
	hpa@zytor.com, magnus.damm@gmail.com, akpm@linux-foundation.org,
	Reloc Kernel List <fastboot@lists.osdl.org>, ak@suse.de,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070307065703.GA23412@in.ibm.com> <20070307071320.GL23412@in.ibm.com> <20070307224157.GD5956@elf.ucw.cz> <20070308042908.GD6000@in.ibm.com> <20070308114335.GD5953@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308114335.GD5953@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 12:43:35PM +0100, Pavel Machek wrote:
> > > > +	movw	$0x0e00 + 'i', %ds:(0xb8012)
> > > > +	movb	$0xa8, %al	;  outb %al, $0x80;
> > > > +
> > > 
> > > > -	movw	$0x0e00 + 'i', %ds:(0xb8012)
> > > > -	movb	$0xa8, %al	;  outb %al, $0x80; 	
> > > 
> > > Outbs were my debugging hacks, perhaps you can simply remove them at
> > > this point? Not sure how useful "Linux" debug print is, it can
> > > probably be removed, too.
> > > 
> > I found these debugging hacks useful while debugging some problem with 
> > my changes in this code. It helps to find out till what poing code flow
> > as reached in this assembly code. So I think its not a bad idea to let
> > this piece code be there.
> 
> Ok. (I was not sure how common are displays of port 0x80).

They're now typically available in reasonably well stocked stores; I picked
one up from CompUSA about a year ago...

-- 
David N. Lombard, Intel, Irvine, CA
I do not speak for Intel Corporation; all comments are strictly my own.
