Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZF2Ssf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZF2Ssf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZF2Ss1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:48:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:8830 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF2Ss1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:48:27 -0400
X-SpamScore: 0
X-BigFish: VPS0(z1039oz98dRzz1202hzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KM0K84-03-1M0-01
Date: Mon, 29 Jun 2009 20:48:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: tom.leiming@gmail.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090629184808.GB9401@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
 <200906281534.37148.arnd@arndb.de>
 <20090629123142.GL5139@amd.com>
 <200906291822.18334.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200906291822.18334.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 18:48:08.0968 (UTC) FILETIME=[255D5880:01C9F8EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 06:22:17PM +0200, Arnd Bergmann wrote:
> As mentioned, the definition of flush_write_buffers() seems a little dodgy,
> I would feel much more comfortable with putting it into the architecture
> specific code or using one of the existing common barriers, since we already
> have so many of them.

Yeah true. We should remove this function if we see that it is not required.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

