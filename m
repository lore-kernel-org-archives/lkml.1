Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXDSPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXDSPgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXDSPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:36:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbXDSPgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:36:31 -0400
Message-ID: <46278C79.10902@redhat.com>
Date: Thu, 19 Apr 2007 11:36:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Upgraded to 2.6.20.7 - positives
References: <fa.M5h51dPMfh17XaHbDXZukR22BGc@ifi.uio.no> <fa.dWJkYfdvni7+ThJwFcV+shx+7TQ@ifi.uio.no> <4626BC13.4060301@shaw.ca>
In-Reply-To: <4626BC13.4060301@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Chuck Ebbert wrote:
>> Denis Vlasenko wrote:
>>> * From make menuconfig questions it looks like SATA/PATA
>>>   rewrite (in the form of libata) is almost finished. Hehe,
>>>   untangling IDE mess was quite a feat, and Jeff did it. Kudos.
>>>
>>
>> ADMA mode on nvidia chipsets still seems broken despite massive
>> amount of SATA fixes backported from 2.6.21...
> 
> News to me.. pleast post details.
> 

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=232811

Comments 24,25 and 26. Apparently setting adma=0 fixes everything.

Kernel 2944 is based on 2.6.20.7 which has tons of SATA fixes from
2.6.21 (maybe still not enough?)

