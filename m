Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbZCXMPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbZCXMPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZCXMPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:15:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46721 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755170AbZCXMPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:15:13 -0400
Date: Tue, 24 Mar 2009 12:16:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
Message-ID: <20090324121608.19f71ce2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324120948.GO12613@charite.de>
References: <20090324120948.GO12613@charite.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 13:09:48 +0100
Ralf Hildebrandt <Ralf.Hildebrandt@charite.de> wrote:

> >From the log:
> 
> Mar 24 09:02:42 proxy-cvk-2 kernel: [   39.078323] tg3 0000:02:02.0: PME# disabled
> Mar 24 09:02:42 proxy-cvk-2 kernel: [   40.600196] tg3 0000:02:02.1: firmware: requesting tigon/tg3_tso.bin
> Mar 24 09:02:42 proxy-cvk-2 kernel: [   41.723404] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> Mar 24 09:02:42 proxy-cvk-2 kernel: [   41.723458] tg3: eth0: Flow control is on for TX and on for RX.
> Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599130] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599184] eth1: TSO capability disabled.
> Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599241] tg3 0000:02:02.1: PME# disabled
> 
> but:
> 
> # ll /lib/firmware/2.6.29/tigon/tg3_tso.bin
> -rw-r--r-- 1 root root 7004 Mar 24 09:24 /lib/firmware/2.6.29/tigon/tg3_tso.bin

Is your userspace configured to use /lib/firmware/2.6.29 or the more
usual /lib/firmware/ ?
