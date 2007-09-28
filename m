Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXI1TLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXI1TLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXI1TK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:10:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43701 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXI1TKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:10:55 -0400
Date: Fri, 28 Sep 2007 22:10:53 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Cedric Le Goater <clg@fr.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.23-rc8-mm2 - tcp_fastretrans_alert() WARNING
In-Reply-To: <46FD20F0.3050909@fr.ibm.com>
Message-ID: <Pine.LNX.4.64.0709282143020.6013@kivilampi-30.cs.helsinki.fi>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
 <46FD20F0.3050909@fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Cedric Le Goater wrote:

> Hello ! 
> 
> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> 
> I just found that warning in my logs. It seems that it's been 
> happening since rc7-mm1 at least. 
> 
> Thanks !
> 
> C.
> 
> WARNING: at /home/legoater/linux/2.6.23-rc8-mm2/net/ipv4/tcp_input.c:2314 tcp_fastretrans_alert()
>
> Call Trace:
>  <IRQ>  [<ffffffff8040fdc3>] tcp_ack+0xcd6/0x1894
> ...snip...

...Thanks for the report, I'll have look what could still break 
fackets_out...

-- 
 i.
