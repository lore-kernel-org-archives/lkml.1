Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYGJIx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYGJIx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGJIxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:53:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYGJIxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:53:47 -0400
Subject: Re: [PATCH] dsp56k: use request_firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Fredrik Noring <noring@nocrew.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Lars Brinkhoff <lars@nocrew.org>,
       Tomas =?ISO-8859-1?Q?Sk=E4re?= <tomas@nocrew.org>
In-Reply-To: <CFF38114-82BA-4A35-B378-8D0A5628E560@nocrew.org>
References: <1215253496.7816.7.camel@jaswinder.satnam>
	 <A3D470E0-953E-40D6-BF5A-D06B76451154@nocrew.org>
	 <1215357224.2817.2.camel@jaswinder.satnam>
	 <43A34816-3B93-4D05-AE0A-65C0FBF35589@nocrew.org>
	 <1215358732.2817.11.camel@jaswinder.satnam>
	 <1215363247.3189.113.camel@shinybook.infradead.org>
	 <35647D7D-85D1-4308-B3A1-63CDCC3F14F7@nocrew.org>
	 <1215608750.11567.177.camel@pmac.infradead.org>
	 <CFF38114-82BA-4A35-B378-8D0A5628E560@nocrew.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 09:53:39 +0100
Message-Id: <1215680019.11567.242.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 09:38 +0200, Fredrik Noring wrote:
> Hi David,
> 
> 9 jul 2008 kl. 15.05 skrev David Woodhouse:
> > It is in fact identical. Disassembly with the tools found on  
> > sourceforge
> > was fun, since they have endianness bugs, don't recognise the 'JMP'
> > which was the first instruction, and need each 3-byte instruction in  
> > the
> > binary to be prefixed with a zero byte to make it 4 bytes. But after
> > sorting that out and going through it instruction by instruction, it
> > really does seem to match.
> 
> Heh. Amazing.
> 
> [ I think the code can be simplified: It currently copies itself to a  
> high program memory location, but this is not necessary because DSP  
> soft reset was never implemented (the reset would have been trapped by  
> the code, in order to load a new program). The driver instead power- 
> cycles the DSP every time a new program is loaded. ]

I did wonder about that. But since we can't test, we're not going to
touch. Better to keep the assembler code which precisely matches the
known-good binary.

-- 
dwmw2

