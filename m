Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYLKIa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYLKIa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYLKIau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:30:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42615 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYLKIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:30:49 -0500
Message-ID: <4940CFB3.8030005@garzik.org>
Date: Thu, 11 Dec 2008 03:30:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: mutahirlatif@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA passthrough commands from User Space
References: <14cd75110812110005n2809dae7n909a606f68ff1a61@mail.gmail.com>
In-Reply-To: <14cd75110812110005n2809dae7n909a606f68ff1a61@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Muhammad Mutahir Latif wrote:
> Hi
> 
> I am new to linux kernel development and need help in developing an
> application in linux for a SATA device. What is required is that the
> application needs to send raw SATA commands along with data (like Read
> DMA, Write FPDMA etc) to a SATA hard disk. Secondly we also have to
> achieve a reasonably high data transfer throughput.

Use the existing SG_IO ioctl.

	Jeff



