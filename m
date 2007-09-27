Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXI0VZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXI0VZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXI0VZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:25:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40111 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753469AbXI0VZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:25:14 -0400
Date: Thu, 27 Sep 2007 22:29:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Brett Warden" <brett.warden@gmail.com>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] bw-qcam: use data_reverse instead of manually poking
 the control register
Message-ID: <20070927222934.010f1898@the-village.bc.nu>
In-Reply-To: <a372714f0709271228r7de8a4a0p4c5d75e939513f08@mail.gmail.com>
References: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
	<2c0942db0709261243h1267140br70796c7fcfb165e3@mail.gmail.com>
	<a372714f0709261306q714100e3t643b31d8f194de2e@mail.gmail.com>
	<2c0942db0709261400l10ef6c3ft2d73d8b2ada4a04@mail.gmail.com>
	<a372714f0709261443p25e99e4at39f4a09c850fb621@mail.gmail.com>
	<a372714f0709271228r7de8a4a0p4c5d75e939513f08@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 12:28:31 -0700
"Brett Warden" <brett.warden@gmail.com> wrote:

> Fixes use of parport_write_control() to match the newer interface that
> requires explicit parport_data_reverse() and parport_data_forward()
> calls. This eliminates the following error message and restores the
> original intended behavior:

Looks good

> parport0 (bw-qcam): use data_reverse for this!
> 
> Also increases threshold in qc_detect() from 300 to 400, as my camera
> often results in a count of approx 330. Added a kernel error message
> to indicate detection failure.

Likewise

> Signed-off-by: Brett T. Warden <brett.warden@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>
