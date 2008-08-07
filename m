Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYHGGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYHGGzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYHGGvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:51:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46026
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbYHGGvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:51:04 -0400
Date: Wed, 06 Aug 2008 23:51:04 -0700 (PDT)
Message-Id: <20080806.235104.131924535.davem@davemloft.net>
To: guijianfeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix kernel panic when calling tcp_v(4/6)_md5_do_lookup
From: David Miller <davem@davemloft.net>
In-Reply-To: <489A99D6.4080809@cn.fujitsu.com>
References: <20080806.224411.210555962.davem@davemloft.net>
	<20080806.224708.172981191.davem@davemloft.net>
	<489A99D6.4080809@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Thu, 07 Aug 2008 14:44:38 +0800

> If the following packet flow happen, kernel will panic.

Applied, let's see if this one build properly :-)
