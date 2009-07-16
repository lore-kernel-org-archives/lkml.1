Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZGPHUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZGPHUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGPHUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:20:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32842 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZGPHUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:20:41 -0400
Message-ID: <4A5ED59C.3010805@redhat.com>
Date: Thu, 16 Jul 2009 09:24:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Jon Smirl <jonsmirl@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Cox <alan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why do we probe option roms at 2K boundaries?
References: <1247698965.3989.1.camel@dwillia2-linux.ch.intel.com>	 <20090716001016.489fa970@lxorguk.ukuu.org.uk>	 <9e4733910907151613n777261e5k3e3c1cd646c7922a@mail.gmail.com> <1247702933.4215.4.camel@dwillia2-linux.ch.intel.com>
In-Reply-To: <1247702933.4215.4.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 07/16/2009 02:08 AM, Dan Williams wrote:
> On Wed, 2009-07-15 at 16:13 -0700, Jon Smirl wrote:
>> On Wed, Jul 15, 2009 at 7:10 PM, Alan Cox<alan@lxorguk.ukuu.org.uk>  wrote:
>>>> interrogating a data structure stored in option-rom memory.  My initial
>>>> implementation involved blindly scanning from c0000 to f0000 in 512 byte
>>>> increments.  Neil and others pointed out that this may not be a safe
>>> It isn't safe. If you hit certain ISA devices your system will drop dead.
>>> OTOH I doubt anyone has an intel matrix raid controller and a WD80x3 on
>>> the same box ;)
>> Random link from google, slide 21
>> http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWAR05005_WinHEC05.ppt
>>
>> PCI 3.0+ allows 512b alignment, but you must first make sure you are
>> on a PCI 3.0+ system.
>
> Thanks, I believe this may be the missing difference between my test
> system and Hans'.
>

Probably, I'll happily test any patches for this you come up with, note that I'm
leaving for a week of vacation tomorrow, so it might take some time for me to
get back to you.

Regards,

Hans
