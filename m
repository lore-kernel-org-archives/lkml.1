Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYADJvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYADJvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYADJv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:51:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51991
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752620AbYADJv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:51:26 -0500
Date: Fri, 04 Jan 2008 01:51:25 -0800 (PST)
Message-Id: <20080104.015125.103222890.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: akpm@linux-foundation.org, johnpol@2ka.mipt.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CONNECTOR: return proper error code in
 cn_call_callback()
From: David Miller <davem@davemloft.net>
In-Reply-To: <477DC9C1.2000209@cn.fujitsu.com>
References: <477DC9C1.2000209@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Fri, 04 Jan 2008 13:53:05 +0800

> Error code should be set to EINVAL instead of ENODEV if !queue_work().
> There's another call of queue_work() which may set err to EINVAL.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

This one is a bug fix so I'll apply it to net-2.6 and push
to Linus.

The rest are cleanups which I'll queue up for 2.6.25

Thanks.
