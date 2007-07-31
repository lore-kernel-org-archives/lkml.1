Return-Path: <linux-kernel-owner+w=401wt.eu-S969517AbXGaEmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969517AbXGaEmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968915AbXGaEg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:36:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44342 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968762AbXGaEgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:36:25 -0400
Date: Tue, 31 Jul 2007 12:35:54 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Badari <pbadari@us.ibm.com>
Cc: Joe Jin <joe.jin@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-ID: <20070731043554.GA3393@joejin-pc.cn.oracle.com>
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AEB055.9050607@us.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.. in this config file, whats causing DIO to panic ? Which test actually
> passing faulty buffer ?
> 

By my testing, just defined job3 and job10 will also get the panic, but if
only have one of them, panic will not appear. the faulty buffer maybe passed
by mmap.

Thanks,
Joe
