Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYJNJM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYJNJM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYJNJMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:12:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:49057 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYJNJMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=KSzmCgpSnEdi3TKnhMjTJ/ZIX7E4H2orGhR34euC2XLQTuuJmh+l1bZapsrG/mEMqA
         9wi3EhsXysH/HGYyYwgGHM0WQg6FoDqiotpXHp9I1E4PIzbB3StG4ec5Gz8/eFr1+4KH
         etZcwhoFAherKYL3Nd5k915WmbExw8RGYvEKM=
Message-ID: <48F46289.5050508@tuffmail.co.uk>
Date: Tue, 14 Oct 2008 10:12:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: Alan Jenkins <aj504@student.cs.york.ac.uk>, Pavel Machek <pavel@suse.cz>,
       Robert Goldner <robert@au-79.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>, linux-stable@vger.kernel.org
Subject: Re: Patch needed for ASUS EEEPC 701 2.6.27 (perhaps a regession)
References: <48F0BD2D.8000001@tuffmail.co.uk> <20081013203648.GA3260@ucw.cz> <48F45D52.2010407@tuffmail.co.uk> <48F46053.6070306@gmail.com>
In-Reply-To: <48F46053.6070306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Alan Jenkins wrote:
>> It could be a coincidence. But it's suspicious enough to advise
>> caution. We know what the bug is, and we have a very nice workaround
>> queued up now. There's no reason to test any more of these specific
>> systems to destruction :).
>> I did try re-installing off the vendor DVD and it was still broken. 
>> I fear I bought it from the wrong place to get sympathetic
>> _frontline_ support / warrantee.  I'm not interested in RMA back to
>> Asus - too much work and downtime for a cheap system, when I have an
>> easy workaround.  I haven't noticed any problems with "noapic".
>>
>>
>> The symptoms strongly suggest overflow in an event buffer or counter
>> maintained by the Embedded Controller.  So the EC firmware may have a
>> bug, of the sort that results in "unspecified behaviour".  A bug in a
>> special purpose (read: not subject to wide testing) subsystem which
>> has direct connections to things like frequency and voltage control.
>>
>> Hopefully I'm wrong, and I don't really know what I'm talking about
>> here.
>>
>> Regards
>> Alan
>>   
> Did you try to disconnect all power resources (e.g. AC adapter and all
> batteries and wait for some time)?

Yes, I tried leaving it with AC + battery unplugged overnight.

> May be there are some default settings in the BIOS?
> This looks small enough to be a HW failure...

I also upgraded the BIOS to the latest version.  And tried the BIOS
setup option to restore defaults.  Maybe there is some more state, but
it's not like a desktop where I can easily remove the CMOS battery.

Thanks
Alan
