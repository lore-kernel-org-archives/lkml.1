Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZKZJWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZKZJWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZKZJWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:22:31 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44317 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066AbZKZJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:22:30 -0500
Date: Thu, 26 Nov 2009 10:22:36 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: wuzhangjin@gmail.com, Andreas Mohr <andi@lisas.de>, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: snd_usb_audio OOPS on MIPSEL - is that the mmap issue?
Message-ID: <20091126092236.GA22408@rhlx01.hs-esslingen.de>
References: <20091125231211.GA19559@rhlx01.hs-esslingen.de> <1259198431.2870.17.camel@falcon.domain.org> <s5h7htdodov.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7htdodov.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 26, 2009 at 10:09:04AM +0100, Takashi Iwai wrote:
> > This bug is really bad, Takashi Iwai and Ralf had a plan to add a
> > dma_mmap_coherent() function for 2.6.34 to fix it eventually.
> > 
> > but for 2.6.33, perhaps that patch is a good temp solution(not enough
> > for the whole bug, but minimally) ;)
> 
> I found a problem with that fix, namely, it doesn't distinguish the
> cases whether it's from dma_alloc_coherent() or directly from
> get_free_pages().  In the latter case, it'd do a wrong address
> conversion.
> 
> I'll try to fix up this issue so that my dma_mmap_coherent()
> conversion can be merged more smoothly in the ALSA core side, and
> report back.

Many thanks to both of you! I'll possibly try either the unmodified patch
or an updated version soon (unless I decide to yank that entire non-working
appliance to /dev/null for the near future, that is ;).

Andreas Mohr
