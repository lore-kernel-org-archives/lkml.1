Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZAUXh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZAUXh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZAUXhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:37:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46467
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbZAUXhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:37:11 -0500
Date: Wed, 21 Jan 2009 15:37:12 -0800 (PST)
Message-Id: <20090121.153712.84781438.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: sam@ravnborg.org, jaswinderlinux@gmail.com, khc@pm.waw.pl,
       jaswinder@kernel.org, arnd@arndb.de, mingo@elte.hu,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: why usr/include/linux/if_frad.h is required
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090121173838.3390e5c9@s6510>
References: <20090121053310.GA26395@uranus.ravnborg.org>
	<20090120.221504.264090722.davem@davemloft.net>
	<20090121173838.3390e5c9@s6510>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 21 Jan 2009 17:38:38 +1100

> There are no references if_frad.h in the version of Sangoma (out of
> tree) code that we use in Vyatta.

frad-0.20:src/dlcicfg.c

It includes linux/if_frad.h and also performs the DLCI_SET_CONF
ioctl.

Enough evidence to show we need to keep this header in the
export set.  Let's just kill the bogus CONFIG_* ifdef
tests in there.
