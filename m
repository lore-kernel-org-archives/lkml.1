Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYACA2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYACA2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYACA16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:27:58 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43328 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbYACA14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:27:56 -0500
Date: Wed, 02 Jan 2008 18:27:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <477B3571.6080500@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kluo@nvidia.com, AMartin@nvidia.com, pchen@nvidia.com
Message-id: <477C2BD4.4030808@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
 <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com>
 <477B0CFD.1030603@shaw.ca> <477B10F2.9000107@shaw.ca>
 <477B1233.3090706@gmail.com> <477B2CE4.8070602@garzik.org>
 <477B318E.4030309@shaw.ca> <477B3571.6080500@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert Hancock wrote:
>> Jeff Garzik wrote:
>>> Tejun Heo wrote:
>>>> Thanks a lot for the detailed explanation.  Nvidia ppl, any ideas?
>>>> FLUSH is used regularly.  We really need to fix this.
>>>
>>> I reiterate my opinion :)  ...   We should remove ADMA support from
>>> sata_nv.  It's only in a few chips, it's not appearing in any new
>>> chips, and nasty problems have lingered since ADMA support was
>>> introduced.
>>>
>>> Definitely sounds like we should disable ADMA by default for
>>> 2.6.24-rc, too.
>> I wouldn't agree.. It's only in a few chips (CK804/MCP04), but those
>> chips are very common in desktop, workstation, even some server
>> machines. Given the huge number of these chips out there, problem
>> reports have been quite rare.
> 
> I agree with Jeff here.  Maybe not remove but disable it by default and
> when enabling warn loudly.  NCQ just doesn't enough for its cost when
> the cost includes erratic behaviors.  Only very small fraction of error
> cases actually make to bugzilla or this mailing list.
> 
> Nvidia gents, is there anyway (be it NDA or whatever) to get Robert or
> any of us technical documentation?
> 
> Thanks.

Last I heard, NVIDIA management gave the thumbs down to any more NDAs 
for ADMA documentation. It would be nice if they would reconsider. 
Apparently Jeff does have the docs, though..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

