Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXKRTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXKRTxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 14:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXKRTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 14:53:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXKRTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 14:53:35 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select which dir to sys_chroot
To: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org, hpa@zytor.com,
       akpm@linux-foundation.org
Reply-To: 7eggert@gmx.de
Date: Sun, 18 Nov 2007 20:53:14 +0100
References: <9qVOO-4ZK-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1ItqCg-0003W2-Qu@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19Val7cXgpoNJCaCNBiLJK59h0k3gLpxRuTvAf
 HzU/mjq+HTRIiDmaAdktZDsIRZ1FRbWiiCWiGnYY9QhBc5SR2S
 5NRdCaJbKhT9CDn7GQAlQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> wrote:

> Second try; this time with a doc-update, and the ability to remount normally.
> 
> Tested against 2.6.23.
> 
> ---
> 
> This patch introduces a rootdir kernel boot parameter, which specifies the
> path to the kernel sys_chroot boot dir.
> 
> This is useful for systems that have more than one distribution installed on
> the same fs/partition.

1) This is useful for booting a rescue or test system, too. In those cases,
   you might want to have the old root moved somewhere.
   (Always "$rootdir/oldroot"? Additional parameter? I'm not sure ...)

2) You use a static buffer, but you don't check for bad return values of
   strlcat().

