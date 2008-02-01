Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYBASTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYBASTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYBASTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:19:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYBASTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:19:13 -0500
Message-ID: <47A361C1.20500@zytor.com>
Date: Fri, 01 Feb 2008 10:15:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk> <20080201131030.GB1477@elte.hu> <47A35F73.7090201@zytor.com>
In-Reply-To: <47A35F73.7090201@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * Ian Campbell <ijc@hellion.org.uk> wrote:
>>
>>> Hi Peter,
>>>
>>> This patch switches the payload of a bzImage file to be in compressed 
>>> ELF format. There are several rough edges which need to be addressed 
>>> before it could go any further but I'd be interested to hear your 
>>> opinion of the general approach before I spend time cleaning it up.
>>>
>>> I'm mainly interested in something along these lines to allow the Xen 
>>> bootloader to load a bzImage so that distros don't have to maintain 
>>> two kernel packages with the same basic bits in different file 
>>> formats, I think it would probably be of use to the kexec and/or 
>>> lguest folks too.
>>
>> this looks quite interesting to me. Peter, what do you think?
>>
> 
> Definitely the right thing, let's just get the rough edges taken care 
> of, in particular the CRC32 bit.
> 

Latest patch looks fine (and is already in the queue), sorry for the noise.

	-hpa
