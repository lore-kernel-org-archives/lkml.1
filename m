Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZKHPpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZKHPpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZKHPpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:45:13 -0500
Received: from outbound-mail-153.bluehost.com ([67.222.39.33]:54573 "HELO
	outbound-mail-153.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750951AbZKHPpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:45:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gm7cALK7VwFICdtfkhLLvqCI5zfTAdjJ0s2WEChkktA5FbAktGHWucwMLuIlq95zJ8eZ1J2L9dH90fEIKi2gf3LCkkApKrxGgvzdak56Z+WVBrMg6UEOXQTI+vMWXNu5;
Date: Sun, 8 Nov 2009 07:45:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v3] x86: Adjust GFP mask handling for coherent
 allocations
Message-ID: <20091108074514.61e6857c@jbarnes-piketon>
In-Reply-To: <20091108111214.GK11372@elte.hu>
References: <4AF18187020000780001D8AA@vpn.id2.novell.com>
	<s5hocnfu0ct.wl%tiwai@suse.de>
	<20091108111214.GK11372@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 12:12:14 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Takashi Iwai <tiwai@suse.de> wrote:
> 
> > At Wed, 04 Nov 2009 12:28:39 +0000,
> > Jan Beulich wrote:
> > > 
> > > Rather than forcing GFP flags and DMA mask to be inconsistent, GFP
> > > flags should be determined even for the fallback device through
> > > dma_alloc_coherent_mask()/dma_alloc_coherent_gfp_flags(). This
> > > restores 64-bit behavior as it was prior to commits
> > > 8965eb19386fdf5ccd0ef8b02593eb8560aa3416 and
> > > 4a367f3a9dbf2e7ffcee4702203479809236ee6e (not sure why there are
> > > two of them), where GFP_DMA was forced on for 32-bit, but not for
> > > 64-bit, with the slight adjustment that afaict even 32-bit
> > > doesn't need this without CONFIG_ISA.
> > > 
> > > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > > Cc: Takashi Iwai <tiwai@suse.de>
> > 
> > Acked-by: Takashi Iwai <tiwai@suse.de>
> 
> Jesse, mind picking this up for .32?
> 
> I've attached below a slightly cleaned up version of the patch, with 
> Takashi's ack added.

Sure, I just stuffed it into my for-linus tree, I'll send a pull req on
Monday or Tuesday.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
