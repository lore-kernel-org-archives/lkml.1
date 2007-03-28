Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXC1NMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXC1NMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXC1NMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:12:51 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:1665 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXC1NMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:12:51 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Oliver Neukum'" <oliver@neukum.org>, <linux-kernel@vger.kernel.org>
Subject: RE: question on tty open and close
Date: Wed, 28 Mar 2007 09:10:26 -0400
Organization: Connect Tech Inc.
Message-ID: <019101c7713a$73bfcce0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <200703281338.29250.oliver@neukum.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: linux-kernel-owner@vger.kernel.org 
> in tty_io.c::tty_open():
[snip]
> We find that a failure in open() leads to release_dev() being called.
> release_dev() calls close():
> 
> 	if (tty->driver->close)
> 		tty->driver->close(tty, filp);
> 
> So we have a file that's closed although open() never succeeded?

That's correct! It's been a pain in my butt for years.

> What's the reason for that?

No idea. Would *love* to hear an explanation.

..Stu

