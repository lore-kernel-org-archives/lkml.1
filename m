Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYKPAMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYKPAMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYKPAMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:12:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35178 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbYKPAMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:12:31 -0500
Date: Sun, 16 Nov 2008 00:12:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116001237.77e60caf@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116010914.1285b884@kopernikus.site>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
	<1226793823-32360-3-git-send-email-bwalle@suse.de>
	<20081116000738.5c70daf5@lxorguk.ukuu.org.uk>
	<20081116010914.1285b884@kopernikus.site>
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

> Well, I think that option makes sense to protect the system
> from processes that *accidentally* read/write to the wrong memory
> location (like the X server that always runs as root).

Older X drivers very carefully only map the memory they need. They also
unmap and remap as well as using iopl/ioperm ranges to avoid such
accidents. Newer ones are all DMA command chains and stuff so it won't
make one iota of difference.

