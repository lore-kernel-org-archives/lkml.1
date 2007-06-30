Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbXF3O3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbXF3O3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbXF3O24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:28:56 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:47034 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757446AbXF3O2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:28:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=vBimGTRAJZxFP0gRspyoU6nxM74hXUvLf+Vcv/7w1Ij7CfZfn3a0fXYdIKOhIqt0JFk1VBVUIqE983iIre8w1XFk4SfBbyjv00WFZq69JN31nkZCzFNotY1lwKRCAIO7DNx2c00GuK3CMsg7ICxMClhRjjcbdfmJFan//q/u1Wo=  ;
X-YMail-OSG: owvHzn4VM1kcnCClysdK4uzp8NuopFsVMkJFk9a4N2sxaHBh
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
Date: Sat, 30 Jun 2007 07:28:48 -0700
User-Agent: KMail/1.9.6
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Yang-r58472 <LeoLi@freescale.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <20070628103619.GW13886@enneenne.com> <20070628141205.GA13886@enneenne.com> <20070628142949.02ca9eab.akpm@linux-foundation.org>
In-Reply-To: <20070628142949.02ca9eab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706300728.48411.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007, Andrew Morton wrote:

> > +#undef	DISABLE_TEST_MODE
> 
> enabling DISABLE_TEST_MODE seens to enable test mode.  Confused.

Blame it on Intel.  ISTR that early pxa2[156]x silicon had
something called "test mode".  And a boatload of errata, with
a common thread in workarounds:  using the "test mode" helped
many things work better, although it was neither necessary nor
sufficient.  If one were to #define DISABLE_TEST_MODE, software
could experiment with other workarounds ... and maybe be able
to get the documented "double buffering" feature to work.

Later silicon stopped documenting "test mode" as such, effectively
making certain workarounds become the standard way to use the chip.

Which doesn't explain why pxa270 code has pxa2[156]x devel hooks,
but explains why pxa2[156]x code wants the hardware "test mode"
to be enabled ... except during developer experiments.

- Dave
