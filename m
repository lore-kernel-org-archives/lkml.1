Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbZJOPgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbZJOPgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbZJOPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:36:36 -0400
Received: from [207.36.208.214] ([207.36.208.214]:39549 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762836AbZJOPgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:36:35 -0400
Message-ID: <4AD74151.7020306@garzik.org>
Date: Thu, 15 Oct 2009 11:35:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>	<4AD711BC.2030409@garzik.org>	<20091015160109.6d9353e8@lxorguk.ukuu.org.uk>	<4AD73E40.1010501@garzik.org> <20091015163103.5e42fabe@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015163103.5e42fabe@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 11:31 AM, Alan Cox wrote:
> EINVAL means you used an ioctl that is correct for the driver but that
> for some reason the driver didn't like it.

Precisely.

The driver author proactively chose to implement the ioctl and return a 
value other than ENOTTY.

It is invalid to assume that all such cases are a direct result of 
author mistakes or ignorance.

	Jeff



