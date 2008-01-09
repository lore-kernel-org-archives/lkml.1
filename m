Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYAIHpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYAIHpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYAIHpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:45:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56615
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbYAIHo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:44:59 -0500
Date: Tue, 08 Jan 2008 23:44:58 -0800 (PST)
Message-Id: <20080108.234458.94292389.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CONNECTOR: don't touch queue dev after decrement of
 ref count
From: David Miller <davem@davemloft.net>
In-Reply-To: <47845F27.6020305@cn.fujitsu.com>
References: <47845F27.6020305@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 09 Jan 2008 13:44:07 +0800

> 
> cn_queue_free_callback() will touch 'dev'(i.e. cbq->pdev),
> so it should be called before atomic_dec(&dev->refcnt).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Excellent catch, patch applied.

Thanks.
