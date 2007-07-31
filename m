Return-Path: <linux-kernel-owner+w=401wt.eu-S940354AbXGaBKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940354AbXGaBKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939167AbXGaBKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:10:09 -0400
Received: from zaphod.dth.net ([85.159.112.68]:34380 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939039AbXGaBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:10:08 -0400
Date: Tue, 31 Jul 2007 03:10:05 +0200
From: Danny ter Haar <dth@dth.net>
To: Len Brown <lenb@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Update: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not:
Message-ID: <20070731011005.GA22245@dth.net>
References: <20070727193832.GA20289@dth.net> <46AC0F6E.2000008@googlemail.com> <20070730025412.GA22888@dth.net> <200707301330.54640.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707301330.54640.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Len Brown (lenb@kernel.org):
> Please attach the output from acpidump to 
> http://bugzilla.kernel.org/show_bug.cgi?id=7880

done
also on : http://www.dth.net/kernel/acpidump_output_via_c3_5000

> We'll likely be able to tell from it if that patch
> has any real effect on your system, or if you test
> result was from some unrelated event.

Reverting the patch didn't make a real difference, it only took
longer (eg 16 minutes before lockup in stead of 2-3 minutes)

> Also, please test with CONFIG_X86_ACPI_CPUFREQ=n
> to remove the acpi-cpufreq driver (and thus this patch)
> from your kernel.  If it still fails, then we know
> that this driver (and this patch) are not related
> to the failure.

Will do.
This machine(firewall) is solar powered so i tried to let it
consume as less power as possible 
This is in my startup script at the moment:

echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

> Hmmm, okay, the "big hammer" works.  Please see
> if any of these smaller hammers work:
> 
> pnpacpi=off
> acpi=noirq
> notsc

More testing to do, however, sunday i'm going abroad for a while,
all stuff will be in storage. If i cant find in the next few days
(packing everything in moving boxes) it might take a while before
i can test again. Sorry for that.

Danny

-- 
