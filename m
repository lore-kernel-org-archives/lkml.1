Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYKVJiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYKVJiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYKVJhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:37:51 -0500
Received: from cet.com.ru ([195.178.208.66]:37658 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYKVJhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:37:51 -0500
Date: Sat, 22 Nov 2008 12:37:49 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John McCutchan <john@johnmccutchan.com>, mtk.manpages@gmail.com,
       Christoph Hellwig <hch@lst.de>, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081122093749.GA12543@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811211939.46812.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 07:39:45PM +0100, Arnd Bergmann (arnd@arndb.de) wrote:
> The how about an inotify_init1 flag telling the kernel to ignore
> changes done by the current PID? That sounds like it is potentially
> useful to other applications that want to monitor the whole file system
> and also write to it. It also doesn't need to change the ABI in
> incompatible ways or introduce a security relevant side channel.

That's a good idea. Robert, John, Michael - comments?

-- 
	Evgeniy Polyakov
