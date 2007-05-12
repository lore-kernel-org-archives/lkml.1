Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXELE34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXELE34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 00:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXELE3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 00:29:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45905 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbXELE3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 00:29:48 -0400
Message-ID: <464542B1.3040403@garzik.org>
Date: Sat, 12 May 2007 00:29:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       "H. Peter Anvin" <hpa@zytor.com>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net> <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
In-Reply-To: <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/11/07, Jonathan Corbet <corbet@lwn.net> wrote:
>> +  - Pointers to data structures in coherent memory which might be 
>> modified
>> +    by I/O devices can, sometimes, legitimately be volatile.  A ring 
>> buffer
>> +    used by a network adapter, where that adapter changes pointers to
>> +    indicate which descriptors have been processed, is an example of 
>> this
>> +    type of situation.
> 
> is a legitimate use case for volatile is still not clear to me (I

IMO it is not.  We do /not/ want to encourage volatile use in those 
cases, and indeed, it's not necessary even if you can rationalize the 
use of the English word "volatile" to describe the situation.

Drivers work quite well without volatile in such situations.

	Jeff


