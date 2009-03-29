Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZC2XgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZC2XgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 19:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZC2XgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 19:36:10 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:9334 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbZC2XgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 19:36:09 -0400
X-Trace: 171259806/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFAPuiz0lQKS+h/2dsb2JhbACBUcUCg3oG
X-IronPort-AV: E=Sophos;i="4.38,442,1233532800"; 
   d="scan'208";a="171259806"
Subject: Re: regression in 2.6.29-git3 on SH/Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1238353446.6471.14.camel@localhost.localdomain>
References: <1238353446.6471.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 00:35:58 +0100
Message-Id: <1238369758.6471.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 20:04 +0100, Adrian McMenamin wrote:
> While 2.6.29 boots cleanly on the Dreamcast, later revisions are likely
> to crash with an OOM condition (this is a race, it doesn't happen on
> every boot, but on about one in every three or four).
> 

Still don't know why this timer patch is tipping the machine over, but I
have found that if I set CONFIG_NO_HZ=y then the machine will boot with
the patch applied.




