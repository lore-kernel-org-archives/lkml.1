Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZCXMRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZCXMRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZCXMRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:17:16 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:46270 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZCXMRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:17:15 -0400
Message-ID: <49C8D09A.2010006@msgid.tls.msk.ru>
Date: Tue, 24 Mar 2009 15:22:50 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
References: <20090324120948.GO12613@charite.de>
In-Reply-To: <20090324120948.GO12613@charite.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Hildebrandt wrote:
> From the log:
> 
> Mar 24 09:02:42 proxy-cvk-2 kernel: [   40.600196] tg3 0000:02:02.1: firmware: requesting tigon/tg3_tso.bin
> Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599130] eth1: Failed to load firmware "tigon/tg3_tso.bin"

> # ll /lib/firmware/2.6.29/tigon/tg3_tso.bin
> -rw-r--r-- 1 root root 7004 Mar 24 09:24 /lib/firmware/2.6.29/tigon/tg3_tso.bin

Shouldn't it be in /lib/firmware/tigon/tg3_tso.bin ?

I mean, are you sure it's kernel and not userspace (udev?) issue?

Starting with 2.6.29, tg3 does not include firmware in the kernel anymore,
as happened with many other drivers already - that was a change for sure.

(which reminds me I have to rework diskless initrd *again* shrug)

/mjt
