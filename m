Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYLOLfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYLOLfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYLOLfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:35:08 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:55617 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbYLOLfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:35:06 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Philipp Kohlbecher <xt28@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <49463F1C.1070401@gmx.de>
References: <49454749.2030901@gmx.de>
	 <1229332954.25349.78.camel@zakaz.uk.xensource.com>
	 <49463F1C.1070401@gmx.de>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 11:34:22 +0000
Message-Id: <1229340862.25349.95.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: documentation fix regarding boot protocol
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=SzA6YOMSqwYA:10 a=v75ATkktc-UA:10 a=0nuXJwdXEkR05GuyYJoA:9 a=9Wtj8EFtjaiKigSHUrs_XJawnS4A:4 a=LY0hPdMaydYA:10 a=lR4PJvqcStcA:10 a=CJCfpgQu0Ck_YsIT:21 a=HpZeb3mc8IjpgBiw:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 12:27 +0100, Philipp Kohlbecher wrote:
> Ian Campbell wrote:
> > On Sun, 2008-12-14 at 18:50 +0100, Philipp Kohlbecher wrote:
> >> Documentation/x86/boot.txt describes payload_offset as the offset
> >> from the end of the real-mode code. In fact, it is more accurately
> >> described as the offset from the beginning of the protected-mode
> >> code, as (a) this is how it is actually calculated and (b) the padding
> >> after the real-mode code is not included in the offset.
> >>
> >> Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>
> > 
> > Acked-by: Ian Campbell <ijc@hellion.org.uk>
> > 
> > The padding after the real-mode code which you mention is just the
> > implicit padding because the size of the real-mode code is specified in
> > sectors (and hence is rounded up), isn't it?
> 
> Yes, it is. You can certainly view the padding as an implicit part of 
> the real-mode code, which is why the current statement isn't wrong -- 
> there is simply room for improvement.

Agreed.

> > Is it worth saying that the payload_offset is relative to (setup_sectors
> > +1) * 512?
> 
> The fact that the protected-mode code starts at that address is already 
> mentioned under the heading "LOADING THE REST OF THE KERNEL" (where 
> protected mode is for some reason referred to as "non-real-mode").

I'd missed/forgotten that section, I don't think anything extra is
needed then.

Ian.

-- 
Ian Campbell
Current Noise: Orange Goblin - Made Of Rats

Fatal Error: Found [MS-Windows] System -> Repartitioning Disk for Linux...
(By cbbrown@io.org, Christopher Browne)

