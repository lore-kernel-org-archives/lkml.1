Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbYD1GlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbYD1GlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbYD1Gk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:40:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34828
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756454AbYD1Gk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:40:58 -0400
Date: Sun, 27 Apr 2008 23:40:58 -0700 (PDT)
Message-Id: <20080427.234058.210327912.davem@davemloft.net>
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427215840.0961be81@laptopd505.fenrus.org>
References: <20080427.174536.62560212.davem@davemloft.net>
	<20080427215840.0961be81@laptopd505.fenrus.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sun, 27 Apr 2008 21:58:40 -0700

> how far would "if you DEPENDS on FOO, and FOO is =m, you can only be
> =m or =n" get us?  or are there hidden traps on this?  (the hard
> case is if a non-tristate DEPENDS on a tristate, but... that's a
> trap anyway)

We want to avoid the problem of users having to sift through the dependency
chain just to figure something like that out.

It's rediculious to require a user to know if the obscure LEDS
subsystem is already set modular or not, for some unrelated reason, in
order to figure out how to build the wireless driver they want
statically into the kernel.

The whole idea behind my suggestion is that the user doesn't have
to know any of this implementation crap.  They just say "I want
wireless, and I want wireless driver X built statically into my
kernel, I don't care how you do it."
