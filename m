Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZAUIN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZAUIN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZAUINt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:13:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:49342 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751659AbZAUINs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:13:48 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/k8Gsq4VXk8HTUqAZ7hOQQQ/i/WucbA/vekHeGYC
	vz8CqOsjEJgZ+H
Message-ID: <4976D937.5040704@gmx.de>
Date: Wed, 21 Jan 2009 09:13:43 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: arnd@arndb.de, jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <1232496257.3123.19.camel@localhost.localdomain>	<20090120.161626.93641145.davem@davemloft.net>	<200901210124.26118.arnd@arndb.de> <20090120.163203.199590606.davem@davemloft.net>
In-Reply-To: <20090120.163203.199590606.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
>> On parisc, there is a major confusion in this area, at some point, all
>> checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
>> not understood what the problem with __LP64__ was, the check for
>> CONFIG_64BIT on parisc user space looks very wrong.

I think the parisc mess is my fault. I once replaced the __LP64__ by 
CONFIG_64BIT and forgot that some files are exported to userspace.
I'll clean that up and send patches.

Thanks for catching this!

Helge
