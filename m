Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbZF2T0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbZF2T0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbZF2TZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:25:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5579 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbZF2TZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:25:41 -0400
X-SpamScore: -15
X-BigFish: VPS-15(z1039oz1432R98dR1805Mzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KM0LXE-04-1AM-01
Date: Mon, 29 Jun 2009 21:24:56 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090629192456.GC9401@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
 <200906291822.18334.arnd@arndb.de>
 <20090629173121.768f2923@lxorguk.ukuu.org.uk>
 <200906291845.16335.arnd@arndb.de>
 <20090629184706.GA9401@amd.com>
 <20090629201026.0f351013@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090629201026.0f351013@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 19:24:57.0238 (UTC) FILETIME=[49989B60:01C9F8EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 08:10:26PM +0100, Alan Cox wrote:
> > X86_OOSTORE is defined for (MWINCHIP3D || MWINCHIPC6) && MTRR. I am not sure if
> > these chips have sfence.
> > It would also help to know what OOSTORE exactly means in the context of that
> > chip.
> 
> Non uncached stores may be visible out of order on the bus.

Ah ok, thanks. I think we should document that somewhere. A help text for the
Kconfig entry comes to my mind for that purpose. I will send a patch for this.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

