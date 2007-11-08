Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbXKHWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbXKHWtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbXKHWsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:48:52 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48012 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760770AbXKHWsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:48:51 -0500
Message-ID: <4733925E.3050208@us.ibm.com>
Date: Thu, 08 Nov 2007 16:49:02 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: ron minnich <rminnich@gmail.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Lguest] [PATCH] virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com> <200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au>  <4732774C.6020903@codemonkey.ws>  <200711090924.28659.rusty@rustcorp.com.au>  <47338EA0.6050100@codemonkey.ws> <13426df10711081447o688550a4jc01be2d7f06209e0@mail.gmail.com>
In-Reply-To: <13426df10711081447o688550a4jc01be2d7f06209e0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ron minnich wrote:
> Hi, I'm sorry, I've been stuck on other things (NFS RDMA anyone?) and
> missed part of this discussion.
>
> Is it really the case that operations on virtio devices will involve
> outl/inl etc.?
>   

No, this is just for the PCI virtio transport.  lguest's virtio 
transport uses hypercalls and shared memory.

Regards,

Anthony Liguori

> Apologies in advance for my failure to pay attention.
>
> thanks
>
> ron
>   

