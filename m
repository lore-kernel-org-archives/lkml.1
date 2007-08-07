Return-Path: <linux-kernel-owner+w=401wt.eu-S934865AbXHGTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934865AbXHGTBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbXHGTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:01:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48299 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbXHGTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:01:36 -0400
Message-ID: <46B8C18D.7040902@garzik.org>
Date: Tue, 07 Aug 2007 15:01:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove genhd.h from header exports
References: <20070807184722.GA31015@aepfle.de>
In-Reply-To: <20070807184722.GA31015@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> remove linux/genhd.h from make headers_install
> 
> It contains no userinterfaces, only the msdos partition table layout and some
> numbers. And it became finally unusable with the CONFIG_BLOCK addition.
> 
> Remove it from the Kconfig list, and remove the __KERNEL__ checks.
> Move #include block up
> remove unused inclusion of linux/major.h
> 
> compile tested with ppc64_defconfig
> 
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

AFAICS the proper fix is to undo the CONFIG_BLOCK breakage, not make the 
header unusable.

	Jeff



