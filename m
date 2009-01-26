Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZAZDp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZAZDp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 22:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZAZDpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 22:45:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:21208 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZAZDpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 22:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C7n3ZoV63YKnPPSkWOlOKaE+dFp1CHG7fgWRWIAslKksZQ9mdbmLrCQQeFPUron7sq
         m6Uk2YOfs6HnKBmRkwxR0SZGiC8o0RCH7J6MefPT+RsO5EfdmKX6CQ0glX/eLZ3bC2cs
         uEdsqDUIJBnT6Jpjus5EtKhCcXd9C8XLfpLD8=
MIME-Version: 1.0
In-Reply-To: <497AD27B.8000204@shaw.ca>
References: <96c9d6a80901221431u16dbf135ife7b59f7b38cb8fa@mail.gmail.com>
	 <497AD27B.8000204@shaw.ca>
Date: Sun, 25 Jan 2009 20:45:14 -0700
Message-ID: <96c9d6a80901251945l7118923ej8bc06943045cd207@mail.gmail.com>
Subject: Re: Did my SATA drive fail? What should I do?
From: Nathan <nathan.stocks@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 1:34 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> Nathan wrote:
>>
>> First off:  Hi!  I'm new to this list.  Googling some of the errors in
>> my logs brought up several posts to this list, none of which led to
>> any obvious resolutions, so I thought I'd try joining the list...
>>
>> I have a linux server[1] that has been acting as an asterisk pbx for
>> about three months without a problem.  Today, the SATA hard drive
>> suddenly went into read-only mode (!?).  Reading seems to work just
>> fine, as I've ssh'd in and looked at a bunch of files, including
>> /var/log/messages [2].
>>
>> Is this just my hardware failing?  Could this a kernel bug?
>> Recommendations?  I would just reboot the thing, but asterisk is still
>> successfully handling dozens of calls right now, despite not being
>> able to write to the disk...
>>
>> [1] # uname -a
>> Linux phoneserver3 2.6.25-gentoo-r7 #2 SMP Thu Oct 16 20:59:53 MDT
>> 2008 x86_64 Intel(R) Xeon(R) CPU E5410 @ 2.33GHz GenuineIntel
>> GNU/Linux
>>
>> [2] (last several lines from /var/log/messages)
>>
>> Jan 22 14:43:09 phoneserver3 dhcpd: DHCPDISCOVER from
>> 00:04:f2:1e:7e:21 via eth2: network 10.254.254/24: no free leases
>> Jan 22 14:43:09 phoneserver3 dhcpd: DHCPDISCOVER from
>> 00:04:f2:1e:7c:6b via eth2: network 10.254.254/24: no free leases
>> Jan 22 14:43:35 phoneserver3 dhcpd: DHCPDISCOVER from
>> 00:04:f2:1e:0d:47 via eth2: network 10.254.254/24: no free leases
>> Jan 22 14:43:36 phoneserver3 dhcpd: DHCPDISCOVER from
>> 00:1f:28:83:00:80 via eth2: network 10.254.254/24: no free leases
>> Jan 22 14:43:41 phoneserver3 ata1.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x0
>> Jan 22 14:43:41 phoneserver3 ata1.00: BMDMA stat 0x25
>> Jan 22 14:43:41 phoneserver3 ata1.00: cmd
>> ca/00:20:00:7c:ef/00:00:00:00:00/ef tag 0 dma 16384 out
>> Jan 22 14:43:41 phoneserver3 res 51/10:20:00:7c:ef/00:00:00:00:00/ef
>> Emask 0x81 (invalid argument)
>> Jan 22 14:43:41 phoneserver3 ata1.00: status: { DRDY ERR }
>> Jan 22 14:43:41 phoneserver3 ata1.00: error: { IDNF }
>
> Most likely this is the disk failing. It's reporting the sector wasn't found
> during a write operation.
>

Thank you for your response!  I will replace the disk just to be safe.

~ Nathan
