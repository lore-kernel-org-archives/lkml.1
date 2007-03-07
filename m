Return-Path: <linux-kernel-owner+w=401wt.eu-S2992721AbXCGWmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992721AbXCGWmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992713AbXCGWmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:42:19 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52718 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992698AbXCGWlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:41:15 -0500
Date: Wed, 7 Mar 2007 23:41:16 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: 2.6.21-rc2-mm2: drivers/net/wireless/libertas/debugfs.c addr bogosity
Message-ID: <20070307224116.GE3441@stusta.de>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070306004408.d3f6434d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 12:44:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc2-mm1:
>...
>  git-netdev-all.patch
>...
>  git trees
>...

drivers/net/wireless/libertas/debugfs.c contains:
  #define item_addr(n) ((u32) &((wlan_adapter *)0)->n)

This is wrong on 64bit architectures.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


