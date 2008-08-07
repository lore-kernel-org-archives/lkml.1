Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYHGPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYHGPus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYHGPuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:50:40 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:61918 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467AbYHGPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:50:39 -0400
Date: Thu, 7 Aug 2008 16:50:24 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: s3c2410_wdt build failure
Message-ID: <20080807155024.GI8301@fluff.org.uk>
References: <20080808003350.3c1671d8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808003350.3c1671d8.sfr@canb.auug.org.au>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:33:50AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> >From an arm s3c2410_defconfig build of today's linux-next (there are no
> commits affecting this file that are not in Linus' tree):
> 
> drivers/watchdog/s3c2410_wdt.c:130: error: redefinition of '__s3c2410wdt_stop'
> drivers/watchdog/s3c2410_wdt.c:119: error: previous definition of '__s3c2410wdt_stop' was here
> 
> Something appears to have gone wrong with commit
> 41dc8b72e37c514f7332cbc3f3dd864910c2a1fa ("s3c2410_wdt watchdog driver:
> Locking and coding style") and we ended up with two versions of
> __s3c2410wdt_stop.

Russell King has already reported this (with my blessing) to the
relevant people.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
