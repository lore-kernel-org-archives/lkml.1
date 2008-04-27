Return-Path: <linux-kernel-owner+w=401wt.eu-S1764419AbYD0W7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764419AbYD0W7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYD0W7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:59:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbYD0W7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:59:24 -0400
Date: Sun, 27 Apr 2008 15:59:24 -0700 (PDT)
Message-Id: <20080427.155924.33536011.davem@davemloft.net>
To: hpa@zytor.com
Cc: jeff@garzik.org, James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: David Miller <davem@davemloft.net>
In-Reply-To: <481504BA.4090402@zytor.com>
References: <20080427.154620.177583216.davem@davemloft.net>
	<481503ED.8060107@garzik.org>
	<481504BA.4090402@zytor.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 27 Apr 2008 15:56:58 -0700

> That one piece of code has had no effective change.  Under both the old 
> and the new code, both branches functionally because ioremap_nocache(), 
> in one case because of MTRR and in one case because of PAT.

Ho hum.. forget the suggestion I made in the reply I just sent out
then. :-/

