Return-Path: <linux-kernel-owner+w=401wt.eu-S934129AbXLQVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbXLQVYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbXLQVY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:24:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbXLQVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:24:26 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: 1st version of azfs
To: Maxim Shchetynin <maxim@de.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Reply-To: 7eggert@gmx.de
Date: Mon, 17 Dec 2007 22:24:14 +0100
References: <9Btcy-1LS-23@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J4NRf-0004mg-0G@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18/bbrr+Hb9udjGJZUTc6jA10SSPupGox/mQZF
 Cz6E1ZQpgTs5cD+IqMmFOmngHS0J4g+ocJ5m9Bb4bxYCJt5y42
 zaKBV35DqQBUOkJdMS2rg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Shchetynin <maxim@de.ibm.com> wrote:

> +config AZ_FS
> +            tristate "AZFS filesystem support"
> +            default m
                       ^
STRONG NACK, I hate digging in the menu tree and hunting for things I
don't need.

> +            help
> +              Non-buffered filesystem for block devices with a gendisk and
> +              with direct_access() method in gendisk->fops.
> +              AZFS does not buffer outgoing traffic and is doing no read
> ahead.
> +              AZFS uses block-size and sector-size provided by block
> device
> +              and gendisk's queue. Though mmap() method is available only
> if
> +              block-size equals to or is greater than system page size.

What is the benefit or intended use of this filesystem? Will your intended
user say "gendisk->fops->direct_access? I wanted to use it all my life"?

AZFZ seems to be an acronym. AirZound File System?
http://globetrotter.de/de/shop/detail.php?mod_nr=ex_35001&GTID=7c553060901a873c5bd29a1846ff39a3a32


