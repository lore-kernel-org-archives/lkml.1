Return-Path: <linux-kernel-owner+w=401wt.eu-S965892AbXCVJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965892AbXCVJRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965893AbXCVJRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:17:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45541 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965892AbXCVJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:17:11 -0400
Subject: Re: 2.6.21-rc4-mm1
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@outflux.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070321115955.GA18195@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <20070320103151.f65c81b6.randy.dunlap@oracle.com>
	 <20070320192016.GC22797@outflux.net>
	 <20070320214714.0e584cd4.akpm@linux-foundation.org>
	 <20070321115955.GA18195@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 09:17:00 +0000
Message-Id: <1174555020.20505.89.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 12:59 +0100, Sam Ravnborg wrote:
> I will give it a shot tonight.

Thanks. I'll delete the syscalls-2.6.git tree now that you have it.

> One issue I have with current approach is that the ARCH specific
> things are in a single .h file. 

Que? There aren't really any arch-specific things, except for a list of
syscalls to be ignored which are i386-specific. That's because we're
pulling in the 'master' system call list from asm-i386/unistd.h, and we
need to exclude some of those which we don't really need on other
architectures.

-- 
dwmw2

