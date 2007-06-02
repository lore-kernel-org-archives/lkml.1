Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbXFBWox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbXFBWox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbXFBWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:44:47 -0400
Received: from enterprise.noxa.de ([212.60.197.71]:42027 "EHLO
	enterprise.noxa.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760793AbXFBWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:44:46 -0400
Date: Sun, 3 Jun 2007 00:43:53 +0200
From: Jonathan Schleifer <js@h3c.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore partition table on device
Message-ID: <20070603004353.3330f35d@localhost>
In-Reply-To: <4661ED70.5000208@zytor.com>
References: <20070602205513.0312ebe0@localhost>
	<4661D32B.2040706@zytor.com>
	<20070602233435.4c432bc5@localhost>
	<4661ED70.5000208@zytor.com>
X-Mailer: Sylpheed-Claws 2.5.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote:

> Partition tables aren't just read at bootup.  We also adjust partition
> tables at runtime.  Since this is dynamic, ignoring partition tables
> should be, too.

So this is something that should be done with a sysctl? Anyway, it
should also be possible to disable it already at bootup.

-- 
Jonathan
