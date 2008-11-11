Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYKKAUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYKKAUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYKKAT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:19:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44078
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbYKKAT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:19:56 -0500
Date: Mon, 10 Nov 2008 16:19:55 -0800 (PST)
Message-Id: <20081110.161955.22624662.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, kosaki.motohiro@jp.fujitsu.com,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/8250: fix uninitialized warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081110155808.a4d94ee7.akpm@linux-foundation.org>
References: <20081110143039.6f21fdc3.akpm@linux-foundation.org>
	<20081110234843.0fba9f16@lxorguk.ukuu.org.uk>
	<20081110155808.a4d94ee7.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 10 Nov 2008 15:58:08 -0800

> On about half the architectures, BUG is not considered to be no-return.

Right, it ought to be, whether implicitly (__builtin_trap() is something
GCC considers no-return) or explicitly (if the arch uses inline
asm or the generic bug.h code)
