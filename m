Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbXGRKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbXGRKmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbXGRKmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:42:04 -0400
Received: from [212.12.190.9] ([212.12.190.9]:32825 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756197AbXGRKmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:42:03 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
Date: Wed, 18 Jul 2007 13:42:00 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181342.00647.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> > Daniel you seem to be right, as till now, no one of those solutions
> > for me worked, I always end up or with a non recognised option or a
> > small square 640x480 pixels where I see the console. I need to try
> > still the vbetest thing what Mr. Daplas proposed.
> >
> > In any case this laptop has an screen of 16:10 aspect ratio and I
> > belive would be good
> > to have those modes in the vesafb driver.
>
> There are no modes in the vesafb driver. The vesafb driver uses the
> video mode that was set by the BIOS before starting Linux.

I have a similar problem with an onboard VIA-UniChrome chip, driven through 
an out-of-tree vendor-supplied driver just to get 85Hz refresh.  Other than 
the pain of maintaining this driver out-of-tree, I have to contend with a 
50% speed reduction compared to vesafb.

vesafb is probably the most important display driver for compatibility 
reasons, and as such should support a large range of functionality.

Is there any technical reason why vesafb shouldn't support non-BIOS modes?


Thanks!

--
Al

