Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXFZFQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXFZFQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXFZFPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:15:53 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:37578 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbXFZFPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:15:52 -0400
Date: Tue, 26 Jun 2007 14:15:36 +0900 (JST)
Message-Id: <20070626.141536.126143027.nemoto@toshiba-tops.co.jp>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, ab@mycable.de, mgreer@mvista.com,
       khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [PATCH 1/2] rtc: add rtc-m41t80 driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070625214620.6a48a02a.akpm@linux-foundation.org>
References: <20070621.020934.59464708.anemo@mba.ocn.ne.jp>
	<20070625214620.6a48a02a.akpm@linux-foundation.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 21:46:20 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > +	const static struct m41t80_chip_info *chip;
> 
> It's a bit weird that `chip' has static storage class here.  Was that
> deliberate?

Oh the variable should not be static!
I will send updated patch.

BTW, I reveived following mails:

Subject: - rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch removed from -mm tree
Subject: - rtc-add-rtc-m41t80-driver-take-2.patch removed from -mm tree
Subject: + rtc-add-rtc-m41t80-driver.patch added to -mm tree
Subject: + rtc-watchdog-support-for-rtc-m41t80-driver.patch added to -mm tree

Are you going back to "take 1" patches?  Why?

---
Atsushi Nemoto
