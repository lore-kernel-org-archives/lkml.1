Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZF1TBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZF1TBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZF1TB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:01:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:26378 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1TB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:01:28 -0400
Date: Sun, 28 Jun 2009 21:01:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: 2.6.31-rc1 build failure: i2c-designware.ko
Message-ID: <20090628210118.15739fbc@hyperion.delvare>
In-Reply-To: <4A47BB88.3090407@imap.cc>
References: <4A47BB88.3090407@imap.cc>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 20:50:48 +0200, Tilman Schmidt wrote:
> I encountered this modpost failure building 2.6.31-rc1:
> 
> Kernel: arch/x86/boot/bzImage is ready  (#2)
>   Building modules, stage 2.
>   MODPOST 1218 modules
> ERROR: "clk_enable" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_get" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_put" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_disable" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_get_rate" [drivers/i2c/busses/i2c-designware.ko] undefined!
> WARNING: modpost: Found 12 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2
> 
> Config attatched.

Already reported half a dozen times, and already fixed:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=47749b14e55cd167632f9a27a4fc439e591e5268

-- 
Jean Delvare
