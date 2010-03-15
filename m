Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab0COFG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:06:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37191
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab0COFG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:06:27 -0400
Date: Sun, 14 Mar 2010 22:06:46 -0700 (PDT)
Message-Id: <20100314.220646.190065794.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, drepper@redhat.com, torvalds@linux-foundation.org,
       munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268628493.2355.2.camel@pasglop>
References: <1268628493.2355.2.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 15 Mar 2010 15:48:13 +1100

> As it is, any 32-bit app using syscall() on any of the syscalls that
> takes 64-bit arguments will be broken, unless the app itself breaks up
> the argument, but the the order of the hi and lo part is different
> between BE and LE architectures ;-)

I think it is even different on the same endian architectures,
f.e. mips I think.

There is no way to do this without some arch specific code
to handle things properly, really.
