Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZIVVZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZIVVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZIVVZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:25:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36515
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbZIVVZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:25:56 -0400
Date: Tue, 22 Sep 2009 14:26:14 -0700 (PDT)
Message-Id: <20090922.142614.257492594.davem@davemloft.net>
To: paul.moore@hp.com
Cc: slash@ma.neweb.ne.jp, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tun: Return -EINVAL if neither IFF_TUN nor IFF_TAP is set.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200909180754.05817.paul.moore@hp.com>
References: <20090917073614.15217260031@msa105lp.auone-net.jp>
	<200909180754.05817.paul.moore@hp.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>
Date: Fri, 18 Sep 2009 07:54:05 -0400

> On Thursday 17 September 2009 03:36:13 am Kusanagi Kouichi wrote:
>> After commit 2b980dbd77d229eb60588802162c9659726b11f4
>> ("lsm: Add hooks to the TUN driver") tun_set_iff doesn't
>> return -EINVAL though neither IFF_TUN nor IFF_TAP is set.
>> 
>> Signed-off-by: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
> 
> Sorry about that, my mistake, thanks for finding and fixing this.
> 
> Reviewed-by: Paul Moore <paul.moore@hp.com>

Applied.
