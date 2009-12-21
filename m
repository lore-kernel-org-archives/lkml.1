Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZLUUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZLUUsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbZLUUsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:48:16 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:50392
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217AbZLUUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:48:16 -0500
Date: Mon, 21 Dec 2009 21:48:03 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
Message-ID: <20091221204802.GA70740@trillian.local>
References: <20091219233457.GA4288@trillian.comsick.at>
 <20091220084656.GA485@merkur.ravnborg.org>
 <20091220091138.GA1793@trillian.comsick.at>
 <20091220100344.GA6614@merkur.ravnborg.org>
 <4B2E084D.6080105@msgid.tls.msk.ru>
 <20091220141156.GA3744@merkur.ravnborg.org>
 <4B2F8369.2060708@suse.cz>
 <20091221162846.GA3529@gibson.comsick.at>
 <4B2FD252.4060700@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2FD252.4060700@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009.12.21 22:53:54 , Michael Tokarev wrote:
> Michael Guntsche wrote:
> > Just a quick update from my side. I tried the patch from Andreas and build a kernel
> > with dash as defaulti shell. I was able to boot the resulting kernel image
> > without any problems.
> 
> That's not a good test case.  Because even with bogus data the kernel might
> boot: for example, allocating alot more memory for the unpacking than necessary -
> it does not crash but the data is still bogus.
> 
> The better (and much faster) check is to verify that the z_output_len value
> in arch/x86/boot/compressed/piggy.S matches the size of
> arch/x86/boot/compressed/vmlinuz.bin.

Looks ok for me.

piggy.S:
z_output_len = 3550876

ls -la vmlinux.bin:
-rwxr-xr-x 1 root root 3550876 Dec 21 17:21 vmlinux.bin


Kind regards,
Michael
