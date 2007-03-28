Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXC1O2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXC1O2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXC1O2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:28:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38654 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752069AbXC1O2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:28:41 -0400
Date: Wed, 28 Mar 2007 16:31:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Stuart MacDonald <stuartm@connecttech.com>,
       "'Oliver Neukum'" <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: question on tty open and close
Message-ID: <20070328163158.658b372a@the-village.bc.nu>
In-Reply-To: <460A8941.4090405@microgate.com>
References: <200703281516.31366.oliver@neukum.org>
	<019201c7713c$1a3277c0$294b82ce@stuartm>
	<20070328154439.40ca5c3c@the-village.bc.nu>
	<460A8941.4090405@microgate.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As long as the new behavior continues to call
> driver->close() if driver->open() succeeds
> then I see no problem.

It breaks if any existing driver is doing no cleanup in ->open() when it
fails but relying upon ->close() being called. That is what needs
auditing first of all.
