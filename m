Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYBKFgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYBKFgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYBKFgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:36:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46999 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYBKFgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:36:13 -0500
Date: Sun, 10 Feb 2008 21:35:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
Message-ID: <20080210213536.5fc17d6a@laptopd505.fenrus.org>
In-Reply-To: <47AFDC4D.4070400@gmail.com>
References: <47AFDC4D.4070400@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 03:25:33 -0200
"Carlos R. Mafra" <crmafra@gmail.com> wrote:

> The problem with suspend to RAM is that right after typing (from
> inside X) 'echo mem > /sys/power/state' the screen becomes black and
> the laptop freezes. I have to use SysRq+b to reboot.
> 
> I tried to revert the above commit (bc71bec) on top of 2.6.25-rc1, but
> the compilation fails. It turns out that I have to revert also
> 9a0b8415 and 9b12e18c to be able to compile without errors. 
> 
> After reverting the 3 commits mentioned above, the resulting
> 2.6.25-rc1 kernel can suspend to RAM again (and I must say that it is
> better that 2.6.24, because now it resumes directly into X and I
> don't need to use Crtl-Alt-F1 and Alt-F7 to go back to X as I used to
> do before).
> 
> The laptop is a Core 2 Duo T7250 2.0 GHz, running Mandriva 2008.0 in
> 64-bit mode, with the following graphics card:
> VGA compatible controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])
> 
> If there is anything else I can do to help please let me know.


this may be a BIOS bug; I'll let Venki dig into this ... but can you send the output of
the dmidecode program to the list? If we need to start blacklisting bioses that information
is going to be needed ;(


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
