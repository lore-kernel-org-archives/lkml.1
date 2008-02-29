Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYB2IZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYB2IZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYB2IZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:25:30 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbYB2IZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:25:29 -0500
Date: Fri, 29 Feb 2008 00:21:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Jeff Garzik <jgarzik@pobox.com>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Message-Id: <20080229002119.5314aad2.akpm@linux-foundation.org>
In-Reply-To: <47C01D03.9030601@gmail.com>
References: <47C01D03.9030601@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 16:17:55 +0300 Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> Theese two patches fix a problem instroduced in Linux 2.6.24, and
> still present in the current Linus' 2.6.25 tree.
> 
> The bcm43xx Wifi driver won't work any more, if the b44 Ethernet
> driver is enabled. This happens because the b44 driver
> needlessly enables the b43_pci_bridge code, which claims
> the same pci ids as the bcm43xx driver. The b43_pci_bridge
> code is needed for the b43{legacy} drivers, but for the
> b44, only the "ssb pci core" is needed.

Hate to stick my head into this beehive, but...

I have a patch queued (the-scheduled-bcm43xx-removal.patch) which 
will remove this driver from 2.6.26.

Is that bad?
