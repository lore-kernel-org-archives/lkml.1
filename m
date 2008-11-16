Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYKPPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYKPPIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYKPPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:08:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51835 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbYKPPIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:08:22 -0500
Date: Sun, 16 Nov 2008 15:07:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com, Bernhard Walle <bwalle@suse.de>
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116150756.3cece2de@lxorguk.ukuu.org.uk>
In-Reply-To: <1226846868-9595-1-git-send-email-bwalle@suse.de>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The protection in the general case and the ability to do live debugging.

What protection. You've completely failed to explain or provide a single
example of any protection provided by the STRICT_DEVMEM code.

> only a half of the story. The truth is that at least RHEL has /dev/crash
> exactly to circumvent that /dev/mem restriction. Don't tell me that this
> is better than having that sysctl entry. ;-)

Which nicely illustrates what a waste of time the whole thing is.

Please do the decent thing and just turn the crap concerned off. The fact
other vendors get it wrong doesn't mean you need to copy. Even better
submit a patch to remove this rubbish from the kernel completely.

Your patch is still adding bells and whistles to a useless turd. In fact
this patch is worse. Without this patch the turd can be disabled and left
out, with your patch everyone now has to compile in said turd pile.

NAK this changeset.

Alan
