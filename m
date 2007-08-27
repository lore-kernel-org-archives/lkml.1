Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbXH0XRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbXH0XRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXH0XRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:17:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34622 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676AbXH0XRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:17:00 -0400
Date: Tue, 28 Aug 2007 01:16:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] clean up exports in fs/{open,read_write}.c
Message-ID: <20070827231659.GO26410@stusta.de>
References: <20070824033310.GA5662@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070824033310.GA5662@kernel.sg>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:33:10AM +0800, Eugene Teo wrote:
> Takashi-san fixed sound/isa/wavefront/wavefront_synth.c to use
> request_firmware instead of sys_*. Since that is the last driver in the
> kernel that uses sys_{read,close}, this patch kills these exports. sys_open
> is left exported for sparc64 only.
>...

fs/binfmt_misc.c still uses sys_close.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

