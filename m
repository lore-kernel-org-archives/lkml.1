Return-Path: <linux-kernel-owner+w=401wt.eu-S934879AbXLQXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879AbXLQXtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936689AbXLQXsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:48:42 -0500
Received: from mail.gatrixx.com ([217.111.11.44]:51162 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936636AbXLQXsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:48:41 -0500
Message-ID: <476709C9.9020503@j-o-a.de>
Date: Tue, 18 Dec 2007 00:44:09 +0100
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de> <20071217223225.GF2310@csclub.uwaterloo.ca>
In-Reply-To: <20071217223225.GF2310@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lennart Sorensen wrote:

[...]

> Isn't it more a matter of having a CF card that does do DMA and a
> controller that does DMA, but a CF to IDE adapter that does not do DMA?
> 
> If it is really a case of a CF card that claims to do DMA but is
> unstable if you try (I have found one model that does so), then it
> should simply be added to the ide dma blacklist instead.

Maybe I will try this also, but for the moment it is running.

> I blacklisted 'SMART CF' on my system since they have random read errors
> and other i/o errors whenever DMA is enabled (while other cards work
> fine with DMA enabled).  They claim to do DMA, but sure don't seem to do
> so reliably on this system.  SiliconDrive CF works perfectly with DMA on
> the same system.

It is working now with "hda=nodma" on kernel 2.6.24-rc5. Thanks to 
Bartlomiej Zolnierkiewicz who gave me the hint to use the newest kernel.

Thanks to all.

Olli
