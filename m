Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZGNTae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZGNTae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZGNTad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:30:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51952 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755869AbZGNTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:30:33 -0400
Date: Tue, 14 Jul 2009 20:31:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090714203123.0ab1f7b8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090714.122704.21107059.davem@davemloft.net>
References: <20090714.122704.21107059.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 8) Locking fix in TTY based networking drivers, from Ralf Baechle.

I thought we had established that this one was wrong following further
discussion. The tty drivers that were calling up from IRQ handlers have
been fixed by the cull of bogus tty->low_latency setting.
