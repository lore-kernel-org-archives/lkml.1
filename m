Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbXBJRE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbXBJRE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXBJRE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:04:56 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:44012 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXBJREz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:04:55 -0500
Date: Sat, 10 Feb 2007 11:04:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: -mm merge plans for 2.6.21
In-reply-to: <fa.2ClW7C4ZyCP9QlT4vg7CbzjSqwg@ifi.uio.no>
To: Frederik Deweerdt <deweerdt@free.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Message-id: <45CDFB30.5090102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7Z67qjqJwFP7+8QiVtu5tq6CZyU@ifi.uio.no>
 <fa.4Y/nCUol/tGEodoOl/Jm9nf2AEA@ifi.uio.no>
 <fa.TgZy4z2lRhwhAWCUE8IuGvMVUCU@ifi.uio.no>
 <fa.HINMjdGzCuxlEiWtVvmNz7Pv9Pc@ifi.uio.no>
 <fa.2ClW7C4ZyCP9QlT4vg7CbzjSqwg@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
>> How about this one instead then:
> Well, the warning you get is not that obvious:
> 
> test.c: In function 'main':
> test.c:11: warning: 'deprecated_irqf' is deprecated
> 
> And as far as I could test (gcc 4.1.1 and gcc 3.4.3), Arjan's comment is
> not true, the "static const int" don't use extra space, they get
> optimized away by the compiler (see http://lkml.org/lkml/2007/2/9/106).

gcc 3.2 should be tested as well, that is still supported by the kernel, 
and versions before 3.4 did not have unit-at-a-time optimizations.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

