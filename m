Return-Path: <linux-kernel-owner+w=401wt.eu-S1030279AbXCCOcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbXCCOcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXCCOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:32:48 -0500
Received: from www.osadl.org ([213.239.205.134]:42567 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030279AbXCCOcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:32:47 -0500
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Mockern@yandex.ru
Subject: Re: Question: 20 microseconds  delay
Date: Sat, 3 Mar 2007 15:33:41 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <45E98415.000002.30135@webmail9.yandex.ru>
In-Reply-To: <45E98415.000002.30135@webmail9.yandex.ru>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703031533.42152.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 03 März 2007 15:20 schrieb Mockern:
> Hi,
>
> I have a question.
>
> I need to use 20 microsecond delay in my driver.
> What exact jiffies value I should define to get 20 microseconds?

You can't do it with jiffies as they have 1 millisecond resolution at best. 
You'd use something like usleep(20) instead.

Hans

