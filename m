Return-Path: <linux-kernel-owner+w=401wt.eu-S935913AbXG2UaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913AbXG2UaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935060AbXG2UaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:30:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60405 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934811AbXG2UaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:30:03 -0400
Date: Sun, 29 Jul 2007 21:37:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with reading DVD using 2.6.21.5
Message-ID: <20070729213714.1d08abac@the-village.bc.nu>
In-Reply-To: <f8huhd$5ia$1@sea.gmane.org>
References: <fa.vjnUHp6KnLRFG9J2YsYgbtTFq/w@ifi.uio.no>
	<fa.KUYdQE3sQ4aqYGIgVcGT0tK2bSE@ifi.uio.no>
	<fa.7w3KoCPMvb0KLfn2mDV9W6PWVrs@ifi.uio.no>
	<fa.cnztXRn3FAFy2ASRJ66hzuGIJeE@ifi.uio.no>
	<46AB6ED2.9050509@shaw.ca>
	<f8huhd$5ia$1@sea.gmane.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As remounting fixes the problem, I think it doesn't have to do anything 
> with the IDE driver, right? The device node should always be connected 
> with the physical device, even if unmount. So the "problem" seems to be 

The IDE driver handles retries, although for IDE the drive itself also
handles them too by default.

> So the question is: What exactly will this "ISO 9660 driver" do, if 
> there is a read error? Will it mark this "failed byte" as "unreadable" 
> and will never try again, or will it try again for at least one ore more 
> times?

It knows nothing about retry - that happens lower down.

