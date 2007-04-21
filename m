Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXDUW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXDUW5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXDUW5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:57:42 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:42048 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbXDUW5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:57:41 -0400
Date: Sat, 21 Apr 2007 16:57:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: problem with <asm/semaphore.h>
In-reply-to: <1177003071.879067.80590@n76g2000hsh.googlegroups.com>
To: liangbowen <liangbowen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <462A96E0.3090006@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1176961482.904618.250700@e65g2000hsc.googlegroups.com>
 <fa.fBTtgscoj66JCf4bIm8v290vCRo@ifi.uio.no>
 <fa.AvTW9UjANJ733AbQtnQmG3hvo7U@ifi.uio.no>
 <fa.BgzkXXMJTw3V0hCHG6tJNpgDbkw@ifi.uio.no>
 <fa.aUMayTTuQ16UFy6Q+LWR4hiTB1Q@ifi.uio.no>
 <fa.633EuMGTHsDpCL9UutDSzsItJUQ@ifi.uio.no>
 <1177003071.879067.80590@n76g2000hsh.googlegroups.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

liangbowen wrote:
> maybe you've misunderstood my meaning.  I mean the whole <asm/
> semaphore.h> header file has only  4 lines of code in total:
> #ifndef I386_SEMAPHORE_H
> #define I386_SEMAPHORE_H
> #include <linux/linkage.h>
> #endif
> 
> it's supposed to have more codes than that. like
> struct semaphore {
> 	int count;
> 	int waking;
> 	int lock ;			/* to make waking testing atomic */
> 	struct wait_queue * wait;
> };
> and the down(), up() functions.
> 
> but I can't see any of those codes, not even the #ifdef __KERNEL__
> macro.
> 

It does in the kernel version of that header. The userspace version of 
that header has everything inside #ifdef __KERNEL__ stripped out.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

