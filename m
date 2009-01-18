Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZARBlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZARBlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 20:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZARBkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 20:40:51 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:29408 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbZARBku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 20:40:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=IuSb1yoApo3u4MTsGnbb+3RoDK5xL9+P22iUZPysNXKh3+PW0zDVmo3ElUczwcr2pZ
         ByrMP8EV0ZRgQ+jo/JTZhDUOUspFRlR/S9VJDybptM1SxLmS/SzroT11i25oNYj9dfL7
         FhTtBGB/8b036D9UEtMhcHqbs78QcjybAOdWg=
Date: Sat, 17 Jan 2009 19:40:45 -0600
From: Jay Cliburn <jcliburn@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [atl2] warn_slowpath in dev_watchdog
Message-ID: <20090117194045.649f55a0@osprey.hogchain.net>
In-Reply-To: <gkt97e$ti0$1@ger.gmane.org>
References: <gkt97e$ti0$1@ger.gmane.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Modifying subject line and cc'ing netdev]

On Sat, 17 Jan 2009 18:49:18 +0000 (UTC)
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On an ever so slightly modified 2.6.28. I think this only happens
> when the upstream router/switch goes out to lunch and packets are
> being sent. It is reproducible but only appears on a home network...
> 
> [  204.704065] ------------[ cut here ]------------
> [  204.704074] WARNING: at net/sched/sch_generic.c:226 dev_watchdog
> +0x22b/0x240()
> [  204.704080] NETDEV WATCHDOG: eth0 (atl2): transmit timed out

Please provide your complete dmesg output.

What do you do to reproduce this?

Can you briefly describe the device immediately upstream of the system producing
the warning?

Thanks,
Jay
