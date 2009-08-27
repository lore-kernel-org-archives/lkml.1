Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbZH0ENI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbZH0ENI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 00:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZH0ENH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 00:13:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZH0ENG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 00:13:06 -0400
Message-ID: <4A9607EC.2080304@redhat.com>
Date: Thu, 27 Aug 2009 07:13:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com> <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com> <4A9585EC.2030505@redhat.com> <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <4A95900D.9090201@redhat.com> <alpine.DEB.2.00.0908261242530.7780@makko.or.mcafeemobile.com> <alpine.DEB.2.00.0908261626410.7780@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908261626410.7780@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 02:30 AM, Davide Libenzi wrote:
> On Wed, 26 Aug 2009, Davide Libenzi wrote:
>
>    
>>> I see no kernel equivalent to read(), but that's easily done.
>>>        
>> Adding an in-kernel read based on "ctx", that is no problem at all.
>>      
> Something like the untested below.
> I had thought you said the eventfd readers where in userspace, but I might
> have misunderstood you.
>    

No, they're all over the place.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

