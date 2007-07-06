Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbXGFCI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbXGFCI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 22:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbXGFCIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 22:08:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040AbXGFCIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 22:08:49 -0400
Message-ID: <468DA42D.7050309@zytor.com>
Date: Thu, 05 Jul 2007 19:08:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707060318160.26869@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> This patch adds the option to not mount another root filesystem 
> by specifying root=initramfs.

Uhm, the kernel doesn't mount anything if you're using an initramfs.

> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?

Not in the stock kernel.  There have been some patches floating around
for that, I think.

	-hpa
