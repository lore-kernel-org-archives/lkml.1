Return-Path: <linux-kernel-owner+w=401wt.eu-S1765383AbYARUov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765383AbYARUov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbYARUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:44:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38605 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757487AbYARUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:44:41 -0500
Date: Fri, 18 Jan 2008 20:40:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
Message-ID: <20080118204030.48fbb683@lxorguk.ukuu.org.uk>
In-Reply-To: <4790F44F.8020009@scram.de>
References: <478F4AE3.5090803@scram.de>
	<20080118183905.2d5d8474@lxorguk.ukuu.org.uk>
	<4790F44F.8020009@scram.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 19:47:43 +0100
Jochen Friedrich <jochen@scram.de> wrote:

> Hi Alan,
> 
> >> If a freescale watchdog device node is present, reset the watchdog
> >> while waiting for serial input.
> > 
> > Why ? We normally rely on user space for watchdog management as only the
> > fact user space is behaving really proves a box is happy ?
> 
> This is in the boot wrapper code, not in the linux kernel.

Ok now that makes sense, thanks
