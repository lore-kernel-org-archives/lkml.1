Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXHVRzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXHVRzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762840AbXHVRze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:55:34 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:63504 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761078AbXHVRze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:55:34 -0400
X-Greylist: delayed 4193 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 13:55:34 EDT
Date: Wed, 22 Aug 2007 19:45:36 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Subject: Re: Kernel oops during netfilter memory allocation
Message-ID: <20070822164536.m7fihwju7bku7lll@m.safari.iki.fi>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
References: <200708201808.08880.thomas.jarosch@intra2net.com> <20070820193103.GC2488@martell.zuzino.mipt.ru> <200708211133.56261.thomas.jarosch@intra2net.com> <200708221709.04992.thomas.jarosch@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221709.04992.thomas.jarosch@intra2net.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 17:09:04 +0200, Thomas Jarosch wrote:
> Hello,
> 
> > > 	kernel BUG at arch/i386/mm/highmem.c:38
> > >
> > > Try this.
> 
> I just tried kernel 2.6.22.4 and 2.6.23-rc3. Using 2.6.23-rc3 vanilla,
> the box survives only 3 seconds with ipt_CRASH. Here's the backtrace,
> it's only slightly different:
> 
> ------------[ cut here ]------------
> kernel BUG at arch/i386/mm/highmem.c:38!
> invalid opcode: 0000 [#1]
> Modules linked in: ipt_CRASH iptable_filter ip_tables x_tables deflate 
> zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher 
> aes xcbcd

What are you using crypto stuff for?
Hopefully you are not calling crypto functions from
IRQ context.

-- 
Do what you love because life is too short for anything else.

