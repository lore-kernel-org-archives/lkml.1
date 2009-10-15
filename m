Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZJOQEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZJOQEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZJOQEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:04:36 -0400
Received: from [207.36.208.214] ([207.36.208.214]:37293 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZJOQEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:04:35 -0400
Message-ID: <4AD747EB.3040008@garzik.org>
Date: Thu, 15 Oct 2009 12:03:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>	<4AD711BC.2030409@garzik.org>	<20091015160109.6d9353e8@lxorguk.ukuu.org.uk>	<4AD73E40.1010501@garzik.org>	<20091015163103.5e42fabe@lxorguk.ukuu.org.uk>	<4AD74151.7020306@garzik.org> <20091015164906.5b2c03db@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015164906.5b2c03db@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 11:49 AM, Alan Cox wrote:
> There are cases where
>
> 	case IOCWIBBLE:
> 		return -EINVAL;
>
> is correct but they are unusual - basically the case where the driver
> author wants to "support" the ioctl but there is no argument that it can
> be given which is correct.

This is the type of case I was referring to.

	Jeff



