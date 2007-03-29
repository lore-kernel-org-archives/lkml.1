Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbXC2NT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbXC2NT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXC2NT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:19:26 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2760 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbXC2NTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:19:25 -0400
Message-ID: <460BBCD8.1020802@rtr.ca>
Date: Thu, 29 Mar 2007 09:19:20 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       Andrew Morton <akpm@osdl.org>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
References: <200703271824.46804.maximlevitsky@gmail.com>
In-Reply-To: <200703271824.46804.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Hi,
> 	I noticed that after suspend/resume cycle all my usb devices are unplugged/replugged by uhci driver.
> While it is not that big problem to me, that can be a real problem if a device is a flash card with mounted 
> file-system, because disappeared device will cause file-system corruption.

Mmm.. this sounds really bad -- I wonder what happens if the rootfs is on USB ?
With older kernels, things just "worked" this way.  Has it now been broken ??

-ml
