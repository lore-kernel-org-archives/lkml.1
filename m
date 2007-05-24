Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbXEXRxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbXEXRxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbXEXRw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:52:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:59115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXEXRw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=VNVLa7sXRuvO+vwSbKcezH8/Jgg6MAPSsy1Sr8Bazv6W1oYXp50PkM3nctLqw7T5btimGlF0fk+1R1NqqdJS1m8yy2yFpnsqFvN5/FJmVNJBVptqRCmqrhC3p1m5cQK2oSKufGtsgz/ku1ToHWz44YD5HD2CRsgeMRj8cUZD15A=
Date: Thu, 24 May 2007 19:38:05 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Message-Id: <20070524193805.1b5d37d9.diegocg@gmail.com>
In-Reply-To: <2172422218943432279@wsc.cz>
References: <2172422218943432279@wsc.cz>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 24 May 2007 16:01:33 +0200 (CEST), Jiri Slaby <jirislaby@gmail.com> escribió:

> +config USB_STK11XX
> +	tristate "STK11XX based webcams"
> +	depends on VIDEO_V4L2
> +	---help---
> +	  This will add support for Syntek webcams such as dc1125 and stk1135.
> +
> +	  If you choose to build it as module, it will be called stk11xx.

Maybe this is a too picky requeriment, but IMO it would be nice if the module
would be called "camera_stk11xx", or had any other prefix that gives some
meaning about what is doing. It's hard to decipher from the name when you run
lsmod.
