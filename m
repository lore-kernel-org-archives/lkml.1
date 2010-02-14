Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0BNJHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:07:24 -0500
Received: from bamako.nerim.net ([62.4.17.28]:55179 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab0BNJHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:07:19 -0500
Date: Sun, 14 Feb 2010 10:07:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214100716.18d9dfe5@hyperion.delvare>
In-Reply-To: <4B7735A7.1050305@s5r6.in-berlin.de>
References: <4B744E13.8040004@kernel.org>
	<20100211205129.GA26105@elf.ucw.cz>
	<20100213181008.479509f5@hyperion.delvare>
	<4B7735A7.1050305@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010 00:28:39 +0100, Stefan Richter wrote:
> Jean Delvare wrote:
> > So the gz option is unsurprisingly faster, setting up the source tree
> > takes almost 3 minutes less (-21%).
> 
> If the download link had been slower than about 75 kB/s, the bz2 option
> would have been faster even on this old machine.
> 
> With xz, download would be faster than bz2 and decompression would be
> somewhere between bz2 and gz --- at least on machines without notable
> memory constraints.  xz's decompressor is more memory hungry than
> bzip2's one as far as I understand their manual pages.  But at the
> default xz compressor setting of -6, the decompressor will still use
> just 10 MB and should therefore not cause even your 64 MB machine to
> swap all the time during decompression.

Note that, if memory consumption is really a concern on either end, we
could use xz -5, which still achieves much better compression than bz2
but doesn't require more memory for decompression.

-- 
Jean Delvare
