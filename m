Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZFOIx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZFOIx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZFOIxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:53:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41855 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881AbZFOIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:53:50 -0400
Date: Mon, 15 Jun 2009 09:54:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Brian Swetland <swetland@google.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, Robert Love <rlove@google.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
 serial	peripheral.
Message-ID: <20090615095454.46b30acb@lxorguk.ukuu.org.uk>
In-Reply-To: <4A35BD7F.3020803@bluewatersys.com>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	<1245033557-10968-2-git-send-email-swetland@google.com>
	<4A35BD7F.3020803@bluewatersys.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
> > +		  UART_MR2);	/* 8N1 */
> > +
> > +	if (baud < 300 || baud > 115200)
> > +		baud = 115200;
> 
> return -EINVAL?

TNo - this is your console so its far better to do something than fail.

