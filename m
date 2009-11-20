Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZKTU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZKTU5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZKTU5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:57:32 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55359 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZKTU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:57:31 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19JNc9GH9oHklAy4eNJp6uP
Date: Fri, 20 Nov 2009 12:57:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: omap tree misaplied patch
Message-ID: <20091120205731.GB5764@atomide.com>
References: <20091120130228.f3b82588.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120130228.f3b82588.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [091119 18:01]:
> Hi Tony,
> 
> I think commit 8552f084d80cfc191ea5affacbeffe44e8629496 ("ARM OMAP3:
> RX-51 board - add initialization of gpio keys") has been misapplied.  It
> has this line:
> 
> 	+#endif /* CONFIG_KEYBOARD_GPIO || CONFIG_KEYBOARD_GPIO_MODULE */
> 
> with the leading '+'.   I noticed this when merging with the input tree
> as this made for a strange looking conflict.

Oops, my fault. Will fix ASAP.

Regards,

Tony

