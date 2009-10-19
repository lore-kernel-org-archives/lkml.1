Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbZJSEYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbZJSEYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 00:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZJSEYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 00:24:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50601
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbZJSEYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 00:24:19 -0400
Date: Sun, 18 Oct 2009 21:24:42 -0700 (PDT)
Message-Id: <20091018.212442.259583006.davem@davemloft.net>
To: thomas@wytron.com.tw
Cc: netdev@vger.kernel.org, thierry.reding@avionic-design.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ethoc: clear only pending irqs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1254961003-2453-2-git-send-email-thomas@wytron.com.tw>
References: <1254961003-2453-1-git-send-email-thomas@wytron.com.tw>
	<1254961003-2453-2-git-send-email-thomas@wytron.com.tw>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Chou <thomas@wytron.com.tw>
Date: Thu,  8 Oct 2009 08:16:43 +0800

> This patch fixed the problem of dropped packets due to lost of
> interrupt requests. We should only clear what was pending at the
> moment we read the irq source reg.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

Applied.
