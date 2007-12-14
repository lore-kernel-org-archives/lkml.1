Return-Path: <linux-kernel-owner+w=401wt.eu-S1764898AbXLNU2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764898AbXLNU2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbXLNU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:28:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33949 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbXLNU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:28:37 -0500
Message-ID: <4762E763.5070800@pobox.com>
Date: Fri, 14 Dec 2007 15:28:19 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: ram.vepa@neterion.com, santosh.rastapur@neterion.com,
       sivakumar.subramani@neterion.com, sreenivasa.honnur@neterion.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/s2io.c section fixes
References: <20071211222306.GV14204@stusta.de>
In-Reply-To: <20071211222306.GV14204@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Code used by the non-__devinit s2io_open() mustn't be __devinit.
> 
> This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.text+0x6f6e3e): Section mismatch: reference to .init.text.20:s2io_test_intr (between 's2io_open' and 's2io_ethtool_sset')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/net/s2io.c |    4 ++--

applied #upstream-fixes


