Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYHWN6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYHWN6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYHWN6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:58:44 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:61041
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbYHWN6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:58:44 -0400
X-Trace: 161250625/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjwFAEe0r0jDlSwG/2dsb2JhbACBZbJNgWg
X-IronPort-AV: E=Sophos;i="4.32,258,1217804400"; 
   d="scan'208";a="161250625"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Sat, 23 Aug 2008 14:58:39 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc4-damocles; KDE/4.1.0; x86_64; ; )
Cc: Jari Aalto <jari.aalto@cante.net>, linux-kernel@vger.kernel.org
References: <87od3k2egi.fsf@jondo.cante.net> <m3vdxrhq0o.fsf@maximus.localdomain>
In-Reply-To: <m3vdxrhq0o.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808231458.39206.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008 13:31:03 Krzysztof Halasa wrote:
> Jari Aalto <jari.aalto@cante.net> writes:
> >         [1] Aug 21 11:01:19 jondo kernel: [174628.275859] DMA: Out of
> > SW-IOMMU space for 65536 bytes at device 0000:00:0d.0 model name      :
> > AMD Athlon(tm) X2 Dual Core Processor
> >         BE-2400
>
> grep GART_IOMMU .config

Agreed, you shouldn't be using the SW-IOMMU on this processor.

That said, do you use the r8169 driver with jumbo frames enabled? Francois 
Romieu just fixed a leak in it that affected Intel platforms (because some 
have no hardware IOMMU).

-- 
Cheers,
Alistair.
