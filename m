Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZERWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZERWn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZERWnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:43:22 -0400
Received: from smtp4.ono.com ([62.42.230.177]:50027 "EHLO resmaa15.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753393AbZERWnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:43:22 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 18:43:21 EDT
Date: Tue, 19 May 2009 00:37:50 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Speed of SDHCI subsystem
Message-ID: <20090519003750.461abe7d@werewolf.home>
X-Mailer: Claws Mail 3.7.1cvs54 (GTK+ 2.17.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have notice something strange with SD cards.
I have an Aspire One and had an 8Gb SDHC card that used for my home,
and have recently upgraded to a 16Gb one.
This new one came with an USB reader.

The thing is that cards look much faster when accessed through the USB
key that directly on the readers of the One.

Some numbers with hdparm:

TakeMS 8Gb Class 6:
	Gives 10MB/s on the slot, 17MB/s via the USB key
SanDisk UltraII 16Gb, Class 4, advertised as 15Mb/s:
	Gives 10MB/s on the slot, 14MB/s on USB

I know that hdparm is not a benchmark, but I supposed it should be
limited by the media, not the connection.

But somehow the SDHCI/MMC subsystem seems to be stuck at 10MB/s, independent
of the quality of the media.

Any ideas ?

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
