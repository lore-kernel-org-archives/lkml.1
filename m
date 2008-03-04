Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYCDG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYCDG0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYCDG0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:26:34 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:42544 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751897AbYCDG0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:26:33 -0500
Date: Tue, 4 Mar 2008 15:26:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh/mm/pg-sh7705.c must #include <linux/fs.h>
Message-ID: <20080304062618.GA29174@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <adrian.bunk@movial.fi>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080303180742.GJ26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303180742.GJ26072@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 08:07:42PM +0200, Adrian Bunk wrote:
> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/mm/pg-sh7705.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/pg-sh7705.c: In function 'ptep_get_and_clear':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/pg-sh7705.c:130: error: implicit declaration of function 'mapping_writably_mapped'
> make[2]: *** [arch/sh/mm/pg-sh7705.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 
Applied, thanks.
