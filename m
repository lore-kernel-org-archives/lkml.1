Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbXG1Wui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbXG1Wui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbXG1Wub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:50:31 -0400
Received: from gw.goop.org ([64.81.55.164]:55122 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbXG1Wua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:50:30 -0400
Message-ID: <46ABC7C0.9060302@goop.org>
Date: Sat, 28 Jul 2007 15:48:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: [PATCH] lib: move kasprintf to a separate file
References: <Pine.SOC.4.64.0706041419470.7370@math> <20070605231712.ff1df46f.akpm@linux-foundation.org> <Pine.SOC.4.64.0707281950340.20474@math.ut.ee> <20070728200450.GA25619@uranus.ravnborg.org> <20070728202012.GB25619@uranus.ravnborg.org>
In-Reply-To: <20070728202012.GB25619@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> kasprintf pulls in kmalloc which proved to be fatal for at least
> bootimage target on alpha.
> Move it to a separate file so only users of kasprintf are exposed
> to the dependency on kmalloc.
>   

OK by me (that's what my original patch did), but it might be worth
documenting what environmental constraints vsprintf.c is under.  I
didn't realize it was used by non-kernel code.

    J
