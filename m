Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXFBU3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXFBU3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXFBU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:29:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXFBU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:29:43 -0400
Message-ID: <4661D32B.2040706@zytor.com>
Date: Sat, 02 Jun 2007 13:29:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jonathan Schleifer <js@h3c.de>
CC: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore partition table on device
References: <20070602205513.0312ebe0@localhost>
In-Reply-To: <20070602205513.0312ebe0@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Schleifer wrote:
> Hello.
> 
> This patch adds a new kernel parameter (ignore_partitions=device) to
> the kernel. It is useful when using a fake RAID with dmraid so that
> Linux won't complain about attemps to access the drive beyond its
> boundaries when udev and/or hald are started.
> 

This seems broken.  If nothing else, there should be ways to enable or
disable this at runtime.

	-hpa
