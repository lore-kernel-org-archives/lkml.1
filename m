Return-Path: <linux-kernel-owner+w=401wt.eu-S1762274AbXEKQsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274AbXEKQsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbXEKQsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:48:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbXEKQse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:48:34 -0400
Message-ID: <46449E59.90608@redhat.com>
Date: Fri, 11 May 2007 12:48:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com> <4643AAF6.7080204@shaw.ca>
In-Reply-To: <4643AAF6.7080204@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>>> +          ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr "
>>> : "",
>>> +          ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
>>> +          ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );
>>
>> I'm not really convinced whether this is necessary.  The human readable
>> form is also a bit cryptic and can get quite long.  So, mild NACK from
>> me.
>>
> 
> It certainly seems useful when debugging hotplug issues or random SATA
> problems which end up being caused by communication problems. Without
> this output, Joe User stands no chance of figuring out what's going on,
> and neither does Joe libata Developer unless they really care to dig
> through the spec and count bits to figure out what they mean. At least
> with this you can see that there was a CRC error, etc. and go from that..
> 

Why not just document the error messages?

And the scsi ones too, I can't seem to find what the sense codes mean.


