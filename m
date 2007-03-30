Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbXC3T0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbXC3T0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXC3T0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:26:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:34890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbXC3T0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:26:23 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Zach <netrek@gmail.com>
Subject: Re: spurious kernel error
Date: Fri, 30 Mar 2007 15:25:06 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <ecfa260c0703300036u5d82389apaaa735ba7de5a3bb@mail.gmail.com>
In-Reply-To: <ecfa260c0703300036u5d82389apaaa735ba7de5a3bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703301525.06460.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2007 03:36, Zach wrote:

> kern.log:Mar 29 23:44:36 netrek kernel: spurious 8259A interrupt: IRQ7.

A spurious interrupt isn't necessarily a "spurious kernel error",
it means that the kernel went to service an interrupt and didn't
find any sources.  In PIC mode, these are registered on IRQ7.
Could be a race condition in a device driver
that is exposed from multiple drivers sharing the same IRQ.

-Len


