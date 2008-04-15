Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYDOHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYDOHjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYDOHjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:39:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbYDOHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:39:08 -0400
Date: Tue, 15 Apr 2008 00:39:10 -0700 (PDT)
Message-Id: <20080415.003910.50277238.davem@davemloft.net>
To: bunk@kernel.org
Cc: aacraid@adaptec.com, James.Bottomley@HansenPartnership.com,
       wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080414141956.GN6695@cs181133002.pp.htv.fi>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 14 Apr 2008 17:19:56 +0300

> This patch fixes the following build error exposed by commit 
> 3a0086a80ab7c2f1adb0e9b2a6fc82632979cec5:

Please provide the commit header text as well as the ID when referring
to commits, because when backported to stable trees the ID might
be different.

I've fixed this up for you.

> <--  snip  -->
> 
>   MODPOST 1741 modules
> ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
