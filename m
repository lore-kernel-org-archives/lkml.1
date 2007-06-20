Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbXFTPlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbXFTPlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXFTPlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:41:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58757 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXFTPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:41:34 -0400
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel
	2.6.21.5
From: Arjan van de Ven <arjan@infradead.org>
To: Alexander Gabert <pappy@gentoo.org>
Cc: libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
       hardened@gentoo.org, torvalds@linux-foundation.org
In-Reply-To: <467948F5.3010709@gentoo.org>
References: <4675C678.3080807@gentoo.org>
	 <1182128803.22999.9.camel@laptopd505.fenrus.org>
	 <4675DFA8.6060703@gentoo.org>
	 <1182130680.22999.13.camel@laptopd505.fenrus.org>
	 <4676601A.7070209@gentoo.org>  <467948F5.3010709@gentoo.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 20 Jun 2007 08:38:00 -0700
Message-Id: <1182353880.2701.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 17:34 +0200, Alexander Gabert wrote:
> Hi,
> 
> http://dev.gentoo.org/~pappy/kernel/linux-2.6.21.5-get_urandom_long-AT_ENTROPY.patch
> 
> this patch adds the function drivers/char/random.c:get_random_long()
> and adds an AT_ENTROPY field in the auxv without config option
> (the config option was removed as suggested by Arjan on LKML).

your patch has some whitespace damage it seems...
other than that I can agree with the approach.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

