Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYHKULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYHKULb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYHKULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:11:22 -0400
Received: from [63.81.120.158] ([63.81.120.158]:36326 "EHLO
	gateway-1237.mvista.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYHKULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:11:21 -0400
Message-ID: <48A09CE5.70402@ct.jp.nec.com>
Date: Mon, 11 Aug 2008 13:11:17 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, Jeff Dike <jdike@addtoit.com>
Subject: Re: linux-next: Tree for August 11
References: <20080811164617.7b06df12.sfr@canb.auug.org.au>
In-Reply-To: <20080811164617.7b06df12.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got an error on um defconfig;

arch/um/drivers/line.c: In function 'line_ioctl':
arch/um/drivers/line.c:306: error: implicit declaration of function 'tioclinux'
make[1]: *** [arch/um/drivers/line.o] Error 1


This commit may cause it.

commit 1aa5f1fab397054a9133bcaf511973db5a6b97be
Author: Alan Cox <alan@redhat.com>
Date:   Mon Aug 11 10:27:35 2008 +1000

    tty-fixup-uml

    Add a new nicer hook for tioclinux

thanks
Hiroshi Shimamoto

