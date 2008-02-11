Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYBKOWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYBKOWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYBKOU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:20:26 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:30694 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229AbYBKOUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:20:23 -0500
X-Trace: 661835653/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAOfnr0dRAVlC/2dsb2JhbACBWaYp
Message-ID: <15561.85.118.17.158.1202739603.squirrel@newgolddream.dyndns.info>
In-Reply-To: <200802101922.29214.vapier@gentoo.org>
References: <1202684222.6237.9.camel@localhost.localdomain>
    <200802101922.29214.vapier@gentoo.org>
Date: Mon, 11 Feb 2008 14:20:03 -0000 (UTC)
Subject: Re: [PATCH 1/2] SH/Dreamcast - joystick (Control pad)
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Mike Frysinger" <vapier@gentoo.org>
Cc: dtor@insightbb.com, "Paul Mundt" <lethal@users.sourceforge.net>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, February 11, 2008 12:22 am, Mike Frysinger wrote:
>
> no remove function ?  looks like the probe() forces a connect, but there's
> no
> remove() to force a disconnect ...


Removing these devices (or any other plugged directly into the maple
ports) is a quick way to destroy your Dreamcast: hence they were never
implemented I guess. But there is no convincing reason for the software
not doing so, I suppose. I can just put in comments about it.

