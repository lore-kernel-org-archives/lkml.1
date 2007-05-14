Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbXENUGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbXENUGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXENUGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:06:34 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:48175 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbXENUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:06:33 -0400
Date: Mon, 14 May 2007 13:04:28 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'  --- resend
In-reply-to: <20070514195046.GF29682@flint.arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, bjorn.helgaas@hp.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4648C0CC.6020402@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com> <46489BC2.6040403@sun.com>
 <4648A310.1050908@sun.com> <20070514181007.GA29682@flint.arm.linux.org.uk>
 <4648B2CC.2020403@sun.com> <20070514191905.GE29682@flint.arm.linux.org.uk>
 <4648BC93.8080909@sun.com> <20070514195046.GF29682@flint.arm.linux.org.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Mon, May 14, 2007 at 12:46:27PM -0700, Yinghai Lu wrote:
>   
>> I don't want to put that there. the problem is serial8250_set_mctrl 
>> called by will clear DTR bit.
>>     
>
> We're at a stalemate then.
>
>   

How about put that line into
serial8250_console_setup
or
serial8250_isa_init_ports

YH

