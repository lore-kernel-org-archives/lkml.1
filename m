Return-Path: <linux-kernel-owner+w=401wt.eu-S934843AbXG0Ho6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbXG0Ho6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763248AbXG0How
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:44:52 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27201 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762821AbXG0Hov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:44:51 -0400
Date: Fri, 27 Jul 2007 15:44:57 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com,
       wen.gang.wang@oracle.com, Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-ID: <20070727074457.GB25084@joejin-pc.cn.oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <a8e1da0707270031u3a4e5616t7cb38356dd86a560@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0707270031u3a4e5616t7cb38356dd86a560@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you are sure the problem is caused by EFAULT or ENOMEM , why not:

To this issue(wengang have posted the background), I hit it for 
do_direct_IO() return EFAULT caused the panic, however, the function
not only return these critical errors, maybe other error return like
EIO.

Thanks,
Joe
