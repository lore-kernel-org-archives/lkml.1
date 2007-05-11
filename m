Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbXEKXKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbXEKXKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbXEKXKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:10:43 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:30320 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXEKXKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:10:41 -0400
Date: Fri, 11 May 2007 17:10:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata: add human-readable error value decoding
In-reply-to: <4644A3AD.7000700@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Message-id: <4644F7EC.3080607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com>
 <4643AAF6.7080204@shaw.ca> <46449E59.90608@redhat.com>
 <4644A3AD.7000700@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Chuck Ebbert wrote:
>> Robert Hancock wrote:
>>>>> +          ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr "
>>>>> : "",
>>>>> +          ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
>>>>> +          ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );
>>>> I'm not really convinced whether this is necessary.  The human readable
>>>> form is also a bit cryptic and can get quite long.  So, mild NACK from
>>>> me.
>>>>
>>> It certainly seems useful when debugging hotplug issues or random SATA
>>> problems which end up being caused by communication problems. Without
>>> this output, Joe User stands no chance of figuring out what's going on,
>>> and neither does Joe libata Developer unless they really care to dig
>>> through the spec and count bits to figure out what they mean. At least
>>> with this you can see that there was a CRC error, etc. and go from that..
>>>
>> Why not just document the error messages?
>>
>> And the scsi ones too, I can't seem to find what the sense codes mean.
> 
> They are well documented elsewhere - the standard documents.  For sense
> codes, t10.org.  For SError bits, t13.org.  You can get drafts free of
> charge.

The ATA ones are more of a pain in that regard than SCSI though - SCSI 
has all distinct error codes for different errors, whereas ATA has 
bitmasks for everything..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

