Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZBISGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZBISGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZBISFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:05:55 -0500
Received: from smtp.nokia.com ([192.100.122.230]:45031 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZBISFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:05:54 -0500
Date: Mon, 9 Feb 2009 19:58:51 +0200
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Pierre Ossman <drzeus@drzeus.dddcx>
Cc: Jean Pihet <jpihet@mvista.com>, Paul Walmsley <paul@pwsan.com>,
       " Hunter Adrian (EXT-Teleca/Helsinki)" <ext-adrian.hunter@nokia.com>,
       OMAP <linux-omap@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       " linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Message-ID: <20090209175851.GA30769@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206145343.2b8a5353@mjolnir.drzeus.cx>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 09 Feb 2009 17:58:53.0958 (UTC) FILETIME=[12359A60:01C98AE0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Related, who is the maintainer of this driver? Tony? I'd like
> to have someone who checks patches before I queue them up.

I can be.  Tony asked me a month ago to set up git tree for OMAP
HSMMC and put the workaround for the HSMMC multi-block DMA read
corruption there, but hate to admit things have been hanging on
todo list.

There are some other fixes waiting. Omap_mmc_set_ios() doesn't
handle power off case correctly and resume from suspend can hang
if the SDBP bit fails to set.

Cheers
Jarkko
