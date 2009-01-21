Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZAUU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZAUU4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZAUU4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:56:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35063
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZAUU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:56:36 -0500
Date: Wed, 21 Jan 2009 12:56:38 -0800 (PST)
Message-Id: <20090121.125638.152447234.davem@davemloft.net>
To: ceggers@gmx.de
Cc: netdev@vger.kernel.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [Resubmit] [PATCH] usb/mcs7830: Don't use buffers from stack
 for USB transfers
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901211248.30794.ceggers@gmx.de>
References: <200901211248.30794.ceggers@gmx.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Eggers <ceggers@gmx.de>
Date: Wed, 21 Jan 2009 12:48:30 +0100

> mcs7830_set_reg() and mcs7830_get_reg() are called with buffers
> from stack which must not be used directly for USB transfers.
> This causes corruption of the stack particulary on non x86
> architectures because DMA may be used for these transfers.
> 
> Signed-off-by: Christian Eggers <christian.eggers@kathrein.de>

Applied, thanks everyone.
