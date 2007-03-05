Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbXCEK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbXCEK2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXCEK2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:28:25 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4774 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbXCEK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:28:24 -0500
Date: Mon, 5 Mar 2007 10:28:14 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: Kernel oops
Message-ID: <20070305102814.GA11689@flint.arm.linux.org.uk>
Mail-Followup-To: Mockern <Mockern@yandex.ru>, linux-kernel@vger.kernel.org
References: <45EBEF9C.000003.25545@tide.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EBEF9C.000003.25545@tide.yandex.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 01:23:24PM +0300, Mockern wrote:
> I have the Linux kernel oops problem sometime.

serial_pxa_irq() was passed a NULL dev_id parameter by the interrupt
layer.  This can only happen if request_irq() was called with a NULL
dev_id parameter.

> How can I fix it?

Show me your modifications to drivers/serial/pxa.c

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
