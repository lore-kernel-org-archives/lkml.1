Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZKXJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZKXJ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbZKXJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:28:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:5477 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbZKXJ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gbfJrxV7M+eOm+WtyoPas8cFqqnwspK/WqGJ/aQgEeje2Sx1ugQhzeCruIzR1K4MgQ
         WzYwNsHJdoI2YCzOtTE4Cyb37WEp8YCwhbYZy85xVb8tUk+GTPIWfZFwjrV/+wYHPyoP
         GujEp0hhWiMK/vOZcR86DEvxCRBjO2GPV5Muo=
Message-ID: <4B0BA725.2050604@tuffmail.co.uk>
Date: Tue, 24 Nov 2009 09:28:05 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Alex Chiang <achiang@hp.com>,
       Tony Luck <tony.luck@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>	 <4B072E31.4000906@tuffmail.co.uk> <20091123195320.GD26810@ldl.fc.hp.com>	 <200911241127.18013.rusty@rustcorp.com.au> <1259041182.2433.945.camel@mulgrave.site>
In-Reply-To: <1259041182.2433.945.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2009-11-24 at 11:27 +1030, Rusty Russell wrote:
>   
>> On Tue, 24 Nov 2009 06:23:20 am Alex Chiang wrote:
>>     
>>> Hi Alan, Rusty,
>>>       
>> Hi Alex,
>>
>>     
>>> In the meantime, while Alan is deciding the proper way to fix
>>> this, would it be possible to drop the offending patch series
>>> from linux-next?
>>>       
>> Done.  That takes the pressure off Alan, and makes sure he has time to get
>> it right.
>>     
>
> That probably suits us on parisc too.  I just checked out our build in
> linux-next: we don't pass __modpost ... it looks like we have all the
> module symbols undefined.  Will investigate more.
>
> James
>   

I think parisc wants P'printk where ia64 uses @fptr(printk).

It may also need ".import printk,code" or similar.

Thanks
Alan

