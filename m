Return-Path: <linux-kernel-owner+w=401wt.eu-S1764428AbXGQHXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764428AbXGQHXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbXGQHXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:23:15 -0400
Received: from 69-12-177-67.dsl.static.sonic.net ([69.12.177.67]:47347 "EHLO
	orion.sysdev.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756459AbXGQHXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:23:14 -0400
Date: Mon, 16 Jul 2007 23:23:57 -0800
From: Tony Borras <tonyb@sysdev.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-Id: <20070716232357.3d9e5ca7.tonyb@sysdev.org>
In-Reply-To: <8HNDE-JM-11@gated-at.bofh.it>
References: <8HJqo-2BV-23@gated-at.bofh.it>
	<8HJqo-2BV-21@gated-at.bofh.it>
	<8HNDE-JM-11@gated-at.bofh.it>
Organization: SysDev Inc.
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i686-pc-linux-gnu)
X-Operating-System: Linux-2.6.27-SMP64
X-SlakBoot: SlakbootIBS v11.0.2
User-Agent: Sylpheed/1.0.6
X-Sylpheed-Rules: You Bet
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 07:20:06 +0200
Willy Tarreau <w@1wt.eu> wrote:

> could you please report what the problem was, in case it's not
> fixed yet ?

Ok, reproduced error at ./net/ipv4/fib_semantics.c
  line 436 changed label:
                   errout -> err_inval

then it builds fine!

started with linux-2.4.34
then patched
     patch-2.4.34.1
     patch-2.4.34.2
     patch-2.4.34.3
     patch-2.4.34.4
     patch-2.4.34.5
     patch-2.4.35.pre5
I used a make oldconfig on a .config that builds in 2.4.34

Hope that helps
TonyB


There are 10 types of people in this world, those that read
binary and those who don't!

--
  __      __  _     I N C.               http://www.sysdev.org
/ __|\\// __||  \  __   __          /         tonyb@sysdev.org
\__ \ \/\__ \||)|/ O_)\/ /        \/  System Tools / Utilities
|___/ || ___/|_ /\___|\_/        WIntel / Linux Device Drivers

