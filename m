Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZAEALw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZAEALw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZAEALl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:11:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58642
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbZAEALk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:11:40 -0500
Date: Sun, 04 Jan 2009 16:11:44 -0800 (PST)
Message-Id: <20090104.161144.119147757.davem@davemloft.net>
To: jaswinder@infradead.org
Cc: jgarzik@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH -net-next 3/4] firmware: convert tg3 driver to
 request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1230626497.24796.26.camel@jaswinder.satnam>
References: <1230626497.24796.26.camel@jaswinder.satnam>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@infradead.org>
Date: Tue, 30 Dec 2008 14:11:37 +0530

> Firmware blob looks like this...
>         u8 firmware_major
>         u8 firmware_minor
>         u8 firmware_fix
>         u8 pad
>         __be32 start_address
>         __be32 length (total, including BSS sections to be zeroed)
>         data... (in __be32 words, which is native for the firmware)
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

I'm simply tired of fighting this, so applied.
