Return-Path: <linux-kernel-owner+w=401wt.eu-S1764173AbXHFVap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764173AbXHFVap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXHFVac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:30:32 -0400
Received: from [212.12.190.89] ([212.12.190.89]:42439 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbXHFVab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:30:31 -0400
From: Al Boldi <a1426z@gawab.com>
To: netdev@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Date: Tue, 7 Aug 2007 00:30:48 +0300
User-Agent: KMail/1.5
References: <JMDDIG$C8916D611655799A77AD19198F8EDA75@xandmail.com>
In-Reply-To: <JMDDIG$C8916D611655799A77AD19198F8EDA75@xandmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708070030.48337.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Baptiste Vignaud wrote:
> Mmm, bad news, after 4 hours of intensive network stressing, one of the 2
> 3com card failed with the latest fedora kernel.
>
> Aug  6 22:31:09 loki kernel: NETDEV WATCHDOG: eth2: transmit timed out
> Aug  6 22:31:09 loki kernel: eth2: transmit timed out, tx_status 00 status
> e601. Aug  6 22:31:09 loki kernel:   diagnostics: net 0ccc media 8880 dma
> 0000003a fifo 8000 Aug  6 22:31:09 loki kernel: eth2: Interrupt posted but
> not delivered -- IRQ blocked by another device? Aug  6 22:31:09 loki
> kernel:   Flags; bus-master 1, dirty 26085000(8) current 26085000(8) Aug 
> 6 22:31:09 loki kernel:   Transmit list 00000000 vs. ffff81007c807700.
>
> Stressing eth2 by copying large files on a samba on share and eth0 by
> downloading big files on the internet.

Next time you want to stress your network you may want to try this:

  # ping 10.1 -s8 -f -l9

or

  # ping 10.1 -s8 -A > /dev/null

BTW, I mentioned this before, there maybe a BIOS irq config mismatch before 
booting the kernel.


Thanks!

--
Al

