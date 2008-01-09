Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYAIJNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYAIJNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYAIJNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:13:09 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50524 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYAIJNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:13:08 -0500
Date: Wed, 9 Jan 2008 12:12:38 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CONNECTOR: don't touch queue dev after decrement of ref count
Message-ID: <20080109091238.GA6250@2ka.mipt.ru>
References: <47845F27.6020305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47845F27.6020305@cn.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:44:07PM +0800, Li Zefan (lizf@cn.fujitsu.com) wrote:
> 
> cn_queue_free_callback() will touch 'dev'(i.e. cbq->pdev),
> so it should be called before atomic_dec(&dev->refcnt).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks a lot!

-- 
	Evgeniy Polyakov
