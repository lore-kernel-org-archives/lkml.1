Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbYG1UoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbYG1UoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759857AbYG1UnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:43:17 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:53041 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759565AbYG1UnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:15 -0400
Date: Tue, 29 Jul 2008 05:42:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Yusuke Goda <goda.yusuke@renesas.com>, Magnus Damm <magnus.damm@gmail.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] SH_AP325RXA must select I2C
Message-ID: <20080728204236.GB20019@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>,
	Yusuke Goda <goda.yusuke@renesas.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728201705.GC7713@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:17:05PM +0300, Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   LD      vmlinux
> arch/sh/boards/renesas/ap325rxa/built-in.o: In function `camera_set_capture':
> setup.c:(.text+0x80): undefined reference to `i2c_get_adapter'
> setup.c:(.text+0x88): undefined reference to `i2c_transfer'
> make[1]: *** [vmlinux] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
The camera stuff should probably just be conditionalized in the platform
code instead.. Magnus, can you sort out the proper dependencies for this?
