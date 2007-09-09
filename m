Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbXIIKGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbXIIKGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 06:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXIIKF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 06:05:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34515 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbXIIKF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 06:05:58 -0400
Date: Sun, 9 Sep 2007 12:07:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checksyscalls.sh: ignore restart_syscall
Message-ID: <20070909100719.GA17423@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0709091131550.6588@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709091131550.6588@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 11:34:11AM +0200, Geert Uytterhoeven wrote:
> checksyscalls.sh: ignore restart_syscall, which is not needed on m68k and
> blackfin.

If only these archs does not care then just stick that
#define __IGNORE_...
in the arch specifc unistd.h files.
x86_64 and other do this already.

Try:
ls include/asm*/unistd.h | xargs grep IGNORE

	Sam
