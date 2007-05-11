Return-Path: <linux-kernel-owner+w=401wt.eu-S1762162AbXEKRMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbXEKRMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbXEKRMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:12:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:27025 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXEKRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jznl6iKua1B7Nx65fR9iJ1AJkH1ZBQsYG1A9zvMto8VPyl2Q+Cn9/06424yDRQx5v/gwKEUDTtq3fIHxiKqaUdG4vfSTq+nemLQX8XRnT9XUA3qAXx3NoWrtvGrrx3D6XbQxX2cbDP4g3HYA5Xcjnq93Si5yMTPu0Ha/1HH78Ec=
Message-ID: <4644A3AD.7000700@gmail.com>
Date: Fri, 11 May 2007 19:11:09 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com> <4643AAF6.7080204@shaw.ca> <46449E59.90608@redhat.com>
In-Reply-To: <46449E59.90608@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Robert Hancock wrote:
>>>> +          ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr "
>>>> : "",
>>>> +          ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
>>>> +          ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );
>>> I'm not really convinced whether this is necessary.  The human readable
>>> form is also a bit cryptic and can get quite long.  So, mild NACK from
>>> me.
>>>
>> It certainly seems useful when debugging hotplug issues or random SATA
>> problems which end up being caused by communication problems. Without
>> this output, Joe User stands no chance of figuring out what's going on,
>> and neither does Joe libata Developer unless they really care to dig
>> through the spec and count bits to figure out what they mean. At least
>> with this you can see that there was a CRC error, etc. and go from that..
>>
> 
> Why not just document the error messages?
> 
> And the scsi ones too, I can't seem to find what the sense codes mean.

They are well documented elsewhere - the standard documents.  For sense
codes, t10.org.  For SError bits, t13.org.  You can get drafts free of
charge.

-- 
tejun
