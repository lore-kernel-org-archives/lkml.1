Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbZCJPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbZCJPjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZCJPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:39:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55269 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbZCJPjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:39:37 -0400
Date: Tue, 10 Mar 2009 15:35:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
Message-ID: <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
In-Reply-To: <1236699004-1863-1-git-send-email-timur@freescale.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This primary purpose of this macro is to poll on a hardware register until a
> status bit changes.  The timeout ensures that the loop still terminates if the
> bit doesn't change as expected.  This macro makes it easier for driver
> developers to perform this kind of operation properly.

NAK this - on a lot of platforms 1uS is the wrong timescale. Also we
shouldn't be encouraging this kind of polling by making it very easy to
write.

It might be a useful internal macro for some freescale drivers but if so
it doesn't belong in the core headers

Alan
