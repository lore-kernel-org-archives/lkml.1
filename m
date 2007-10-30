Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXJ3IMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXJ3IMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXJ3IMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:12:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38059
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbXJ3IMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:12:32 -0400
Date: Tue, 30 Oct 2007 01:12:08 -0700 (PDT)
Message-Id: <20071030.011208.266664843.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: 12o3l@tiscali.nl
Subject: Re: + lmc_ioctl-dont-return-with-locks-held.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710292100.l9TL0DPg023005@imap1.linux-foundation.org>
References: <200710292100.l9TL0DPg023005@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Mon, 29 Oct 2007 14:00:13 -0700

> Subject: lmc_ioctl: don't return with locks held
> From: Roel Kluin <12o3l@tiscali.nl>
> 
> (akpm: it's doing copy_to_user() inside spin_lock_irqsave(): this driver
> appears to be beyond help).
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This patch is definitely an improvement, applied :-)
