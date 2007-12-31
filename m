Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXLaODn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXLaODn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 09:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXLaODc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 09:03:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49796 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXLaODb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 09:03:31 -0500
Date: Mon, 31 Dec 2007 15:03:20 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: David Miller <davem@davemloft.net>
cc: 7eggert@gmx.de, jengelh@computergmbh.de, devzero@web.de,
       linux-kernel@vger.kernel.org, bunk@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
In-Reply-To: <20071231.042055.145660385.davem@davemloft.net>
Message-ID: <alpine.LSU.0.999.0712311426520.3761@be1.lrz>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
 <20071231.042055.145660385.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+pgKi73CP64L25BaGX0xHcZX6SqKzG8cg9WGl
 ZmcAN/xSLH7Fn4iH4Gc7Pys8vnBE3u3zn2H+PMiT4y+3PXnj4f
 FSe9D+UFyowu+OfwyjWWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007, David Miller wrote:
> From: Bodo Eggert <7eggert@gmx.de>

> > As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> > on normal systems. This is especially true since udev needs these sockets
> > and fails to run if UNIX=m.
> > 
> > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> 
> People who use udev can make sure they have it built into their kernel
> if they have such a dependency.
> 
> Not everyone uses udev, and therefore needs AF_UNIX non-modular.

That's why I kept this option for embedded folks.

Is there any benefit for non-embedded systems from having UNIX=m?
-- 
Top 100 things you don't want the sysadmin to say:
89. I got a better job at Lockheed...
