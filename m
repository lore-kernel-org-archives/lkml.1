Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbZBTIn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbZBTIn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZBTInq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:43:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32972
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbZBTInp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:43:45 -0500
Date: Fri, 20 Feb 2009 00:43:26 -0800 (PST)
Message-Id: <20090220.004326.246398596.davem@davemloft.net>
To: tklein@de.ibm.com
Cc: jeff@garzik.org, raisch@de.ibm.com, hering2@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ehea: Fix memory hotplug handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902191232.12152.tklein@de.ibm.com>
References: <200902191232.12152.tklein@de.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Klein <tklein@de.ibm.com>
Date: Thu, 19 Feb 2009 12:32:11 +0100

> Added missing set_bit() to disable data transfer when a memchange
> notification is handled
>
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

Applied to net-next-2.6

But this was a real pain because you never tell me what
tree your changes are destined for.

I assumed since you said "bug fix" you want this in
net-2.6, but of course this patch doesn't apply there
since the driver version is different in that tree.

You can save me all of that trial-and-error wasted time
if you simply say "net-next-2.6" or "net-2.6" either
in the "[PATCH ...]" part of your subject or in the
message body itself.

Thanks.
