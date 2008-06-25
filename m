Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYFYCR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYFYCR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYFYCRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:17:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45436 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752764AbYFYCRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:17:17 -0400
Date: Tue, 24 Jun 2008 21:17:11 -0500
From: Paul Jackson <pj@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: yhlu.kernel@gmail.com, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
Message-Id: <20080624211711.8c6d5105.pj@sgi.com>
In-Reply-To: <4861A5DF.5010104@zytor.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	<20080623060939.6b6b3183.pj@sgi.com>
	<86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>
	<20080624203252.f932c631.pj@sgi.com>
	<4861A5DF.5010104@zytor.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa wrote:
> that would have to be %#10lx.

Hmmm ... the '#' is a good idea, instead of an explicit "0x".

Do we want zero padding as well, with "0#8lx" ?

Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00428000

or right aligned, space padded:

Zone PFN ranges:
  DMA             0x0 ->     0x1000
  DMA32        0x1000 ->   0x100000
  Normal     0x100000 ->   0x428000

I like the zero padding here myself.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
