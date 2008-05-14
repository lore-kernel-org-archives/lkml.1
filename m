Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYENPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYENPbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYENPbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:31:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:35630 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYENPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=Y9FWfSm7hVawNLOPc3NBOcqsNGdYgbYRHS+dvPAFNYSx+ZHJdfy5iH+4w86xBbkeOSftUHel/pmefTvHelqE0nCcnbKxRA+pG0BREwc1C1o9HT11M5JTZgWzmHEazENxBzdrBTsnDeYSbTSqeKGWaQEgWqAm+mg+41sCRIWd8Ko=
Date: Wed, 14 May 2008 19:31:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514153104.GE6902@cvg>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de> <20080514144031.GA6902@cvg> <je63thszo6.fsf@sykes.suse.de> <20080514151407.GD6902@cvg> <je1w44ucrc.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <je1w44ucrc.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andreas Schwab - Wed, May 14, 2008 at 05:27:35PM +0200]
| Cyrill Gorcunov <gorcunov@gmail.com> writes:
| 
| > Andreas, could you test/review the following patch
| > (what is worse - I *have* introduced buffer overflow with my
| > patch, so I think we should fix it asap)
| 
| I've compiled the file with the various cross compilers I have laying
| around here, no reference to strlen any more.
| 
| Andreas.
| 
| -- 
| Andreas Schwab, SuSE Labs, schwab@suse.de
| SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
| PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
| "And now for something completely different."
| 

Thanks a lot, Andreas! I'll sent the patch to Linus, 'case having potential buffer overflow
is not good for mainline

		- Cyrill -
