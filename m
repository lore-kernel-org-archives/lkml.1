Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYFBUW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYFBUW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYFBUVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:21:39 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:55711 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYFBUVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:21:38 -0400
Date: Mon, 2 Jun 2008 23:21:35 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602202135.GF3700@mea-ext.zmailer.org>
References: <20080601161510.GA26854@enneenne.com> <20080602075113.60d0fdf8@core> <20080602092551.GC26854@enneenne.com> <20080602150257.54692f35@core> <20080602145603.GG26854@enneenne.com> <20080602164840.0dc9cb96@core> <20080602172203.GI26854@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602172203.GI26854@enneenne.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 07:22:03PM +0200, Rodolfo Giometti wrote:
...
> In the past we noticed that just moving up the getnstimeofday() of
> only one instruction, from:
> 
> 	port->icount.dcd++;
> 	getnstimeofday(&ts);
> 
> to:
> 
> 	getnstimeofday(&ts);
> 	port->icount.dcd++;
> 
> the time precision improved from 5ms to 2ms...

Perhaps I am looking for unattainable..  but I have HP/Agilent 58534A
(a.k.a Symmetricom 58534A) "GPS Timing Antenna",  which specifications
are telling that it should attain 1PPS timing jitter of less than 40 ns
in proper stabilized position hold mode.

Can that level be handled with standard PC hardware, or should the time
keeping and core parts of NTP be delegated into FPGA entirely ?
Stratum-1 is rather demanding, after all...

> However, if you prefere that I add the if clause, I'll do it.
> Thanks,
> Rodolfo 

Thanks,  Matti
