Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXGJQ1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXGJQ1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbXGJQ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:26:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59987 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760658AbXGJQ0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:26:09 -0400
Message-ID: <4693B320.4030003@garzik.org>
Date: Tue, 10 Jul 2007 12:26:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] tokenring/3c359.c:xl_init() must be __devinit
References: <20070710124437.GS3492@stusta.de>
In-Reply-To: <20070710124437.GS3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following section mismatch:
> 
> <--  snip  -->
> 
> ...
>   MODPOST vmlinux
> WARNING: drivers/built-in.o(.text+0x361ef1): Section mismatch: reference to .init.text:xl_init (between 'xl_probe' and 'xl_hw_reset')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


