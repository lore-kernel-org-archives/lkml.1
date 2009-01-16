Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbZAPTFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbZAPTFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZAPTEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:04:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33548
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756195AbZAPTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:04:51 -0500
Date: Fri, 16 Jan 2009 11:04:52 -0800 (PST)
Message-Id: <20090116.110452.77631610.davem@davemloft.net>
To: dhananjay@netxen.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] netxen: include ipv6.h (fixes build failure)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1232130484-25188-3-git-send-email-dhananjay@netxen.com>
References: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
	<1232130484-25188-3-git-send-email-dhananjay@netxen.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhananjay Phadke <dhananjay@netxen.com>
Date: Fri, 16 Jan 2009 10:28:04 -0800

> Fixes a build error in absence of CONFIG_IPV6:
> 
> drivers/net/netxen/netxen_nic_main.c:1189: error: implicit declaration of function 'ipv6_hdr'
> drivers/net/netxen/netxen_nic_main.c:1189: error: invalid type argument of '->'
> 
> Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>

Gee, thanks for not even mentioning Ingo having reported this problem
in your commit message. :-((

I've fixed this when committing.

You didn't even CC: him on this patch posting, what gives?

