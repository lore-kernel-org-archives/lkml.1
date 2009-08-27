Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbZH0IIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbZH0IIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZH0IIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZH0IIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:08:15 -0400
Date: Thu, 27 Aug 2009 11:06:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090827080647.GA7460@redhat.com>
References: <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com> <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com> <4A9585EC.2030505@redhat.com> <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <4A95900D.9090201@redhat.com> <alpine.DEB.2.00.0908261242530.7780@makko.or.mcafeemobile.com> <alpine.DEB.2.00.0908261626410.7780@makko.or.mcafeemobile.com> <4A9607EC.2080304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9607EC.2080304@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 07:13:32AM +0300, Avi Kivity wrote:
> On 08/27/2009 02:30 AM, Davide Libenzi wrote:
>> On Wed, 26 Aug 2009, Davide Libenzi wrote:
>>
>>    
>>>> I see no kernel equivalent to read(), but that's easily done.
>>>>        
>>> Adding an in-kernel read based on "ctx", that is no problem at all.
>>>      
>> Something like the untested below.
>> I had thought you said the eventfd readers where in userspace, but I might
>> have misunderstood you.
>>    
>
> No, they're all over the place.

Further, with Davide's proposal you must be a reader to signal events.

> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
