Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbYCEMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbYCEMTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYCEMSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:18:37 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51062 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYCEMSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:18:36 -0500
Message-ID: <47CE8F90.7060607@pobox.com>
Date: Wed, 05 Mar 2008 07:18:24 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: geert@linux-m68k.org, zippel@linux-m68k.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [2.6 patch] fix drivers/net/atarilance.c compilation
References: <20080303213413.GN26072@cs181133002.pp.htv.fi>
In-Reply-To: <20080303213413.GN26072@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/net/atarilance.o
> {standard input}: Assembler messages:
> {standard input}:406: Error: symbol `Lberr' is already defined
> {standard input}:460: Error: symbol `Lberr' is already defined
> make[3]: *** [drivers/net/atarilance.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied


