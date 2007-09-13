Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXIMQGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXIMQGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbXIMQGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:06:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48331 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbXIMQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:06:42 -0400
Date: Thu, 13 Sep 2007 09:08:06 -0700
From: Reza Roboubi <reza@parvan.net>
Subject: Re: TCP_LINGER2 TIME_WAIT
In-reply-to: <p73ir6eyk7d.fsf@bingen.suse.de>
To: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <46E96066.2030505@parvan.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <46E8B491.2080107@parvan.net> <p73ir6eyk7d.fsf@bingen.suse.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Reza Roboubi <reza@parvan.net> writes:
> 
>> man 7 tcp says TCP_LINGER2 sets the lifetime of orphaned FIN_WAIT2 state
>> sockets.  What about wanting to forcibly kill a "rotten" TCP socket in
>> any other "WAIT" state like TIME_WAIT?
> 
> The whole point of TIME-WAIT is catching old packets still in network.
> Killing it early would avoid its purpose.

tcp_max_tw_buckets does exactly that system wide, and for good reason. 
Why not give userspace oversight over the process?

Reza.
