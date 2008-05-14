Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYENOkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYENOkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbYENOkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:40:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:13489 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYENOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=kOuGNpTd+DLriKXhgEoSGgRNvwtOfHgkPbv+pvrPJY03IEmoKh8zn7NLbLE9nwwPTdtb0nwKAYflQPP2ZgsMLubFnBF6tKUd78VIlUuq9eamjZePR4SDr8vkKt6K2Ss/+G9wjzGG+8/XElAlV3Hn1eyfieaoFFFR1A3bjx5QbMA=
Date: Wed, 14 May 2008 18:40:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514144031.GA6902@cvg>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jeabitt0xj.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andreas Schwab - Wed, May 14, 2008 at 04:28:24PM +0200]
| Adrian Bunk <bunk@kernel.org> writes:
| 
| > Or replace all the strlen stuff in include/asm-m68k/string.h with a 
| 
| I don't think the strlen macros has any influence in this case (it
| already uses __builtin_strlen anyway).  I'd rather guess that gcc is
| expanding strncat internally to something involving strlen with
| non-constant argument, although I cannot see how that can happen from a
| quick look.
| 
| Andreas.
| 
| -- 
| Andreas Schwab, SuSE Labs, schwab@suse.de
| SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
| PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
| "And now for something completely different."
| 

I think it would help to see ..tmp_vmlinux1.cmd to ensure for inclusion
of lib/lib.a. strlen was there without my patch as Andreas already pointed,
I've just added strncat wich is coming from lib/string.o for this arch.

		- Cyrill -
