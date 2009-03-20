Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZCTCJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZCTCJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZCTCJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:09:00 -0400
Received: from outboundproxy4.bluehost.com ([74.220.195.67]:57822 "HELO
	outboundproxy4.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752668AbZCTCJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:09:00 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 22:09:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=D20DmaIPmHYx2LkiW2ZBuwypCoJ+aM48949Jm5rKZXqo9qPb8LfJuaYGAuHFPFu49MkpkAFrTbTMtAM+/GibDP5FVJvnYLPQ7BApfaQyo2Twf7zHbmrNkibwfCZLMgw1;
Date: Thu, 19 Mar 2009 19:02:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] pci/x86: try to detect host_bridge pci_cfg_space -v2
Message-ID: <20090319190216.3eebf988@hobbes.lan>
In-Reply-To: <49B49C99.3030603@kernel.org>
References: <49B1C81B.5010904@zytor.com>
	<20090308110437.GA27811@elte.hu>
	<20090308145803.GL25995@parisc-linux.org>
	<49B4330C.1060700@zytor.com>
	<49B4343B.9050807@kernel.org>
	<49B43585.2050606@zytor.com>
	<49B436E4.1050103@kernel.org>
	<20090308220100.GO25995@parisc-linux.org>
	<49B44182.1030707@zytor.com>
	<20090308222804.GA25376@elte.hu>
	<86802c440903081600l517c22ccj6328633c01131cb1@mail.gmail.com>
	<49B49C99.3030603@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Mar 2009 21:35:37 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: get correct pci_cfg_size for host_bridge
> 
> more host bridges support 4k cfg, so check them directy instead of
> quirks.
> 
> only need to do this extra check for host_bridge at this point,
> because only host bridges are known to have extended address space
> without also having a PCI-X/PCI-E caps.
> other devices we could still do quirks for them if there is any.
> 
> also remove the quirks for AMD host bridges with family 10h and 11h
> that is not needed any more
> 
> with this patch, we can get correct pci cfg size of new Intel
> CPUs/IOHs with host bridges
> 
> v2: updated commit log.

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
