Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZHCR0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZHCR0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHCR0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:26:36 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55633 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZHCR0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:26:35 -0400
X-Greylist: delayed 2658 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 13:26:35 EDT
Message-ID: <4A77132A.4080005@cs.wisc.edu>
Date: Mon, 03 Aug 2009 11:41:14 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, open-iscsi@googlegroups.com
Subject: Re: [RFC 0/2] new kfifo API
References: <1249306755.8358.8.camel@wall-e> <200908031642.15136.arnd@arndb.de>
In-Reply-To: <200908031642.15136.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 09:42 AM, Arnd Bergmann wrote:
> On Monday 03 August 2009, Stefani Seibold wrote:
>> This is a proposal of a new generic kernel FIFO implementation.
>>
>> The current kernel fifo API is not very widely used, because it has to many
>> constrains. Only 13 files in the current 2.6.30 used it. FIFO's are
>> like list are a very basic thing and a kfifo API which handles the most use
>> case would save a lot of time and memory resources.
>>
>> I think there are the following reasons why kfifo is not in use.
>>
>> - There is a need of a spinlock despite you need it or not
>> - A fifo can only allocated dynamically
>> - There is no support for data records inside a fifo
>> - The FIFO size can only a power of two


For iscsi, the only thing we have not liked with the current code is 
having to have the fifo a power of 2. It has not been that big a deal 
though.
