Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYKILuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYKILuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYKILup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:50:45 -0500
Received: from bu3sch.de ([62.75.166.246]:51362 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbYKILuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:50:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] SSB: make it depend on PCI
Date: Sun, 9 Nov 2008 12:49:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mike Frysinger <vapier@gentoo.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1225965082-31462-1-git-send-email-vapier@gentoo.org> <8bd0f97a0811060315j7d11e1a7p257a4a1bea640f7b@mail.gmail.com> <Pine.LNX.4.64.0811091149280.19341@anakin>
In-Reply-To: <Pine.LNX.4.64.0811091149280.19341@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091249.52071.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 November 2008 11:51:37 Geert Uytterhoeven wrote:
> I had the same issue on m68k, not only with SSB but also with other legacy
> drivers (hp100 Ethernet, AIC7xxx SCSI). It was fixed in commit
> 998aaf01c6f6f3dffc1ea9e7b20b131e38fdbc78 ("m68k: <asm/pci.h> needs
> <asm-generic/pci-dma-compat.h>").

Ok, nice.
I'd suggest we additionally fix the architectures this way.

My patch already is on its way upstream and I think that's OK.
The codepaths that it #ifdefs out are dead code on non-PCI, so I think
it's OK to #ifdef them.

-- 
Greetings Michael.
