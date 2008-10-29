Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYJ2URc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYJ2URc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYJ2URY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:17:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753431AbYJ2URX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:17:23 -0400
Date: Wed, 29 Oct 2008 20:17:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oskar Liljeblad <oskar@osk.mine.nu>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
Message-ID: <20081029201724.0a7d736e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081029185856.GA8152@osk.mine.nu>
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>
	<49079E09.20703@shaw.ca>
	<20081029185856.GA8152@osk.mine.nu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Anyway Seagate (inofficially) claims it's a driver issue in Linux - from
> http://forums.seagate.com/stx/board/message?board.id=ata_drives&thread.id=2390&view=by_date_ascending&page=6

Well then perhaps they would care to share the information with us 8)

The HPA size reporting one is certinly Linux, the flush cache one I don't
think is. The fact Mac people report it and Seagate suggest workarounds
of the form of "don't use 33% of the disk" don't inspire confidence.

>   "We already know about the Linux issue, it is indeed a kernel error
>   causing the problem as it was explained to me by one of our developers."

Well if they'd care to explain it to linux-ide perhaps we can find a work
around. I would be cautious about disabling the write caching as it will
harm both performance and probably drive lifetime.

Alan
