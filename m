Return-Path: <linux-kernel-owner+w=401wt.eu-S1751361AbXEXPSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbXEXPSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXEXPSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:18:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42279 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXEXPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:18:13 -0400
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
	input/output speed
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070524160559.54c2c639@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 24 May 2007 11:18:21 -0400
Message-Id: <1180019901.8303.104.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 16:05 +0100, Alan Cox wrote:
> 
> > Likewise, I assume the lack of IBSHIFT on PowerPC is because of AIX?
> 
> I assume nobody ever got around to it. CIBAUD is in the PowerPC System V
> API supplement for example and is supported by other Power OS's.

Hm... what we have in asm-powerpc/termbits.h doesn't seem to match
what's in ppc-sysv-1995-09.ps.gz. Where _should_ I be looking?

Paulus?

-- 
dwmw2

