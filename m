Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXH1Fgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXH1Fgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbXH1Fgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:36:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbXH1Fgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:36:41 -0400
Date: Mon, 27 Aug 2007 22:36:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Message-Id: <20070827223638.0aa903ce.akpm@linux-foundation.org>
In-Reply-To: <46D3B394.9090609@gmail.com>
References: <300725321593711206@pripojeni.net>
	<20070827154049.8c5e61fe.akpm@linux-foundation.org>
	<46D3B394.9090609@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 07:33:08 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> > Again, ARRAY_SIZE() would be clearer here.
> 
> No, this is only do this 16 times, no corresponding table :).

OK, poorly chosen example.  But there are lots of others, like:

+
+	for (i = 0; i < 59; i++) {
+		stk11xx_read_dummy(dev, 0x02ff);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+		stk11xx_write_reg(dev, 0x0204, values_204[i]);
+		stk11xx_write_reg(dev, 0x0205, values_205[i]);

