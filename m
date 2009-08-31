Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZHaPmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZHaPmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZHaPmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:42:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36198 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZHaPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:42:51 -0400
Date: Mon, 31 Aug 2009 11:42:42 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
Message-ID: <20090831154242.GB2105@hmsreliant.think-freely.org>
References: <4A9B6963.5090207@cn.fujitsu.com> <4A9B6E57.7090703@gmail.com> <20090831111245.GA2105@hmsreliant.think-freely.org> <4A9BD13E.4040501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A9BD13E.4040501@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 03:33:50PM +0200, Eric Dumazet wrote:
> Neil Horman a écrit :
> > I still see a large number of drivers that update dev->last_rx, although its
> > not all as I look through the list, so something definately seems amiss.
> 
> Some drivers still update dev->last_rx for their own needs, not a core
> network concern.
> 
> But a cleanup is certainly possible on few other drivers, about a dozen
> if I count correctly.
> 
> > 
> > If its not going to be consistently updated, why are still carrying that field
> > in dev?  Are we just waiting on someone to do the janitorial work to remove it?
> > If so, I can, and I'll fix up the drop monitor in the process, to use a private
> > timestamp.
> 
> We have to keep dev->last_rx for bonding use, so please use a private
> timestamp for drop monitor.
> 

Copy that, I'll submit a drop monitor patch for this sometime this week.  Thanks
for the heads up!
Neil

> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
