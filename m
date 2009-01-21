Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbZAUAcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbZAUAcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbZAUAcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:32:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53959
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757715AbZAUAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:32:01 -0500
Date: Tue, 20 Jan 2009 16:32:03 -0800 (PST)
Message-Id: <20090120.163203.199590606.davem@davemloft.net>
To: arnd@arndb.de
Cc: jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901210124.26118.arnd@arndb.de>
References: <1232496257.3123.19.camel@localhost.localdomain>
	<20090120.161626.93641145.davem@davemloft.net>
	<200901210124.26118.arnd@arndb.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 21 Jan 2009 01:24:25 +0100

> I think we should simply define a macro for use in the kernel, e.g. in
> <asm/types.h>. There already is a BITS_PER_LONG macro in there, maybe
> we can add an exported __BITS_PER_LONG there that checks for the right
> macro on each architecture.

That might work.

> On parisc, there is a major confusion in this area, at some point, all
> checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
> not understood what the problem with __LP64__ was, the check for
> CONFIG_64BIT on parisc user space looks very wrong.

Yep.
