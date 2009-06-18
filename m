Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZFRTiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZFRTiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZFRTin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:38:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46759
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbZFRTim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:38:42 -0400
Date: Thu, 18 Jun 2009 12:38:45 -0700 (PDT)
Message-Id: <20090618.123845.232783995.davem@davemloft.net>
To: swetland@google.com
Cc: pavel@ucw.cz, arve@android.com, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com, greg@kroah.com
Subject: Re: HTC Dream aka. t-mobile g1 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <a55d774e0906181233p35b60cd2ga401bd1304267643@mail.gmail.com>
References: <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com>
	<20090618101309.GC28892@elf.ucw.cz>
	<a55d774e0906181233p35b60cd2ga401bd1304267643@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Swetland <swetland@google.com>
Date: Thu, 18 Jun 2009 12:33:48 -0700

> Yeah, I wasn't sure how to handle this.  We try to keep the msm/dream
> stuff in a state that doesn't break other parts of the tree, but there
> doesn't seem to be support for different keymaps for different
> devices.

How it's supposed to work is that you have a specific keyboard driver
and that emits PC keyboard codes into the core kernel using a
translation table in your driver.

For example on Sparc machines we have a Sun Type-4/5 keyboard driver,
but all applications and the kernel see PC keycodes.
