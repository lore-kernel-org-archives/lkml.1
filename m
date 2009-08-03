Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZHCTCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZHCTCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZHCTCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:02:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54319
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617AbZHCTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:02:21 -0400
Date: Mon, 03 Aug 2009 12:02:30 -0700 (PDT)
Message-Id: <20090803.120230.197595669.davem@davemloft.net>
To: Geert.Uytterhoeven@sonycom.com
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drop superfluous casts in nr_free_pages() callers
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
References: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Mon, 3 Aug 2009 18:11:42 +0200 (CEST)

> Commit 96177299416dbccb73b54e6b344260154a445375 ("Drop free_pages()")
> modified nr_free_pages() to return 'unsigned long' instead of 'unsigned int'.
> This made the casts to 'unsigned long' in most callers superfluous, hence
> remove them.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: David S. Miller <davem@davemloft.net>
