Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbYFCN42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbYFCN42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYFCN4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:56:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41225 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752547AbYFCN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:56:18 -0400
Date: Tue, 3 Jun 2008 14:40:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080603144058.6a7f3216@core>
In-Reply-To: <20080602202135.GF3700@mea-ext.zmailer.org>
References: <20080601161510.GA26854@enneenne.com>
	<20080602075113.60d0fdf8@core>
	<20080602092551.GC26854@enneenne.com>
	<20080602150257.54692f35@core>
	<20080602145603.GG26854@enneenne.com>
	<20080602164840.0dc9cb96@core>
	<20080602172203.GI26854@enneenne.com>
	<20080602202135.GF3700@mea-ext.zmailer.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps I am looking for unattainable..  but I have HP/Agilent 58534A
> (a.k.a Symmetricom 58534A) "GPS Timing Antenna",  which specifications
> are telling that it should attain 1PPS timing jitter of less than 40 ns
> in proper stabilized position hold mode.
> 
> Can that level be handled with standard PC hardware, or should the time
> keeping and core parts of NTP be delegated into FPGA entirely ?
> Stratum-1 is rather demanding, after all...

That depends on what the NTP logic needs. Hardware IRQ time stamping is
fairly easy to do and providing your algorithms work with knowing the
time that the event occurred relative to a timer on the stamping device
(+/- bus delays and inaccuracies in the timers) you can get very good
numbers - but I doubt in the 40nS range.

Alan (who actually worked on a time stamping hardware toy almost 20 years
ago)

