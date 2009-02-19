Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZBSJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZBSJbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZBSJa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:30:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59221 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZBSJa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:30:57 -0500
Message-ID: <499D2728.1080208@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 17:32:24 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCHv2 00/11]Get rid of all the old macro DMA_nBIT_MASK and use
 DMA_BIT_MASK(n) instead
References: <499CFDC8.1070600@cn.fujitsu.com> <499D0221.9090407@cn.fujitsu.com> <20090219081403.GA5400@elte.hu> <499D1ED9.4040005@cn.fujitsu.com>
In-Reply-To: <499D1ED9.4040005@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:fix s/micro/macro typo and keep the old defines
            of DMA_nBIT_MASK
----------------------
Replace all DMA_nBIT_MASK macro with the new DMA_BIT_MASK(n) macro

01:Replace all DMA_64BIT_MASK macro with DMA_BIT_MASK(64)
02:Replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
03:Replace all DMA_40BIT_MASK macro with DMA_BIT_MASK(40)
04:Replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)
05:Replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)
06:Replace all DMA_32BIT_MASK macro with DMA_BIT_MASK(32)
07:Replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)
08:Replace all DMA_30BIT_MASK macro with DMA_BIT_MASK(30)
09:Replace all DMA_28BIT_MASK macro with DMA_BIT_MASK(28)
10:Replace all DMA_24BIT_MASK macro with DMA_BIT_MASK(24)
11:Update the old macro DMA_nBIT_MASK related documentations

-- 
Regards
Yang Hongyang
