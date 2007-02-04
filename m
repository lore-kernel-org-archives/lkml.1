Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXBCXxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXBCXxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXBCXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:53:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59298 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751596AbXBCXxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:53:45 -0500
Date: Sun, 4 Feb 2007 00:05:53 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
Message-ID: <20070204000553.18c102d4@localhost.localdomain>
In-Reply-To: <45C51B81.5040309@jonmasters.org>
References: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
	<Pine.LNX.4.61.0702032136430.13874@yvahk01.tjqt.qr>
	<20070203222141.6f723fd9@localhost.localdomain>
	<45C51B81.5040309@jonmasters.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway. Are we doing this or not - the more I think about it, the more 
> I'm kinda "happy" to just leave things as they are. Yes, bad people will 
> continuing doing bad things no matter what we do. Do we really want to 
> change stuff just to work around obvious abuse? Alan?

Actually checking the ELF sections does make the loader more robust and
we need to fix up the off by one as well so I think so yes. When I
thought about this I was happy I'd have said yes without modules doing
GPL\0
