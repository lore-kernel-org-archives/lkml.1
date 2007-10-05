Return-Path: <linux-kernel-owner+w=401wt.eu-S1764078AbXJEUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764078AbXJEUV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762066AbXJEUVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:21:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:57246 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762051AbXJEUVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:21:50 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19OmUx8a59OUZB15CmjTaY/Qm7XYGDQ5H6nMfA4R2
	n56gFFC2M2hasm
Date: Fri, 5 Oct 2007 22:22:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>
cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Various problems on Axis 700 Lite VIA C7
In-Reply-To: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.60.0710052215510.10392@poirot.grange>
References: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ok, after a day of biseting, it turns out to be a compiler problem. The 
gcc-3.3.5 produces at least these two problems (Oops on i2c-viapro probe 
and disabled IRQs in USB), whereas 4.1.2 has no problem so far. Up to now 
3.3.5 had no problem compiling 2.6.20+ kernels here, for example, for P-II 
SMP. Does it at all look realistic that such "random" run-time problems 
are caused by a miscompilation?...

Thanks
Guennadi
---
Guennadi Liakhovetski
