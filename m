Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbXJXOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbXJXOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXJXOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:25:51 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52375 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXJXOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:25:50 -0400
Date: Wed, 24 Oct 2007 08:24:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: test_and_set_bit and friends ?
In-reply-to: <fa.9c/G28WUUK+ko/84Dr2THTV2Bls@ifi.uio.no>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Hounschell <markh@compro.net>
Message-id: <471F55A4.8090604@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.qZKT99AD2hc7Jh4djYdvRApuWLw@ifi.uio.no>
 <fa.9c/G28WUUK+ko/84Dr2THTV2Bls@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Mark Hounschell wrote:
>> These calls apparently are gone. Can someone tell me why and what are
>> the replacements.
>>
>> Thanks in advance
>> Mark
>>
> 
> I got no response from the glibc people on this and the kernel-newbies
> list appears dead so I thought I'd try here since these calls are/were
> actually kernel based to begin with. Why are they no longer available in
> user space and what is one supposed to use now?

In general, none of the kernel synchronization-type functions should 
have been used in userspace since they often depend on infrastructure 
which is only in the kernel in order to work properly. The new headers 
installation system strips out any code intended for kernel use only 
from the userspace-visible headers.

(Not to mention the licensing issues - the kernel is GPL, not LGPL, so 
only GPL programs could have legally done so in the first place.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

