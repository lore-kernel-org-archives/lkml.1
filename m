Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbXJFPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbXJFPKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 11:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbXJFPKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 11:10:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:35971 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757393AbXJFPKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:10:34 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18usAJ1sr0uwDAzaqKdjh77jxKduTvKy1pafws+gM
	Qtjngs56hDiJtB
Date: Sat, 6 Oct 2007 17:10:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       i2c@lm-sensors.org
Subject: Re: [i2c] Various problems on Axis 700 Lite VIA C7
In-Reply-To: <Pine.LNX.4.60.0710052257140.10392@poirot.grange>
Message-ID: <Pine.LNX.4.60.0710061706450.7276@poirot.grange>
References: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
 <Pine.LNX.4.60.0710052215510.10392@poirot.grange> <4706A2F7.8050508@msgid.tls.msk.ru>
 <Pine.LNX.4.60.0710052257140.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:

> On Sat, 6 Oct 2007, Michael Tokarev wrote:
> 
> [snip]
> > That to say - it may be some miscompilations, but may be some probs with
> > hardware itself.  If you can, try to reproduce the same on another board
> > (I just tried to boot 2.6.23-rc5 on this machine, compiled for PIII CPU
> > using gcc-4.1.2 (no other version installed, sorry) - no issues so far).
> 
> Hm, well, I could only compile a i686 kernel and Intel chipset with 
> "otherwise the same" config with these two compiler options to test... 
> Maybe some time. No, I do not have another C7 system.

No, doesn't work. I forgot that on that PC I can only boot with 
"acpi=noirq", so, the whole ACPI IRQ-mapping code is not used. Otherwise, 
I did build such a kernel for that PC - noticed no problem. So, either the 
only two "miscompiled" places were i2c-viapro and acpi irq routing, or 
indeed it only triggers problems on C7...

Thanks
Guennadi
---
Guennadi Liakhovetski
