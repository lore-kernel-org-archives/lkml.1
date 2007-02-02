Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXBBJSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXBBJSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXBBJSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:18:13 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:41842 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXBBJSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:18:12 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 04:18:12 EST
Date: Fri, 2 Feb 2007 11:10:59 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: zhangxiliang <zhangxiliang@nanjing-fnst.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ntp
Message-ID: <20070202091059.GB3438@mea-ext.zmailer.org>
References: <026801c746a6$c3f81780$2801a8c0@zhangxiliang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026801c746a6$c3f81780$2801a8c0@zhangxiliang>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 04:47:26PM +0800, zhangxiliang wrote:
> When i start the ntp service successful on server, the client must
> ntpdate with the server after waiting a moment.
> The moment may be 3~5 minutes, or it may be 10~15 minutes. I don't
> know why it happens?

The  ntp server  takes several external clock comparisons to know its
local running environments (hosts) clock behaviour.

Before it knows that, it has no real knowledge of what the time is,
and it won't report anything out.

In my environments I have couple local machines (usually doing
something else too) assigned as network local NTP servers, and
all other machines refer to them.


> Regards
> Zhang Xiliang
> MAIL:zhangxiliang@nanjing-fnst.com

/Matti Aarnio
