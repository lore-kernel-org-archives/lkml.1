Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbYDVOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbYDVOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbYDVOi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:38:58 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:47682 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbYDVOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hChYQWdV5rmcP7wS4JcIoETzybQJgfP4ld+L0Pye8mwtFP1Iwbve3l/HiHEn90j6HxcaAOibay6CEXJ3asPBf9/OKhseJsIvM8lKppYpDXlpRpH4ZDwTESjZhuYyAlwvZQe4YqHukrnK6tlSEz/DNe+oPiVkEIG10Wr0YtCF3+8=
Message-ID: <480DF876.7070800@gmail.com>
Date: Tue, 22 Apr 2008 23:38:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca>
In-Reply-To: <480DF7B7.9030000@rtr.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Sergei Shtylyov wrote:
>>>>>    Jeff, Tejun, what "sff" in the file name actually means? Isn't 
>>>>> it strange that the drivers lacking DMA support or not really 
>>>>> compliant with SFF-8038i have to link with this file?
>>>
>>>> Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma)
>>>> and bmdma is acceptable, hopefully, right?
>>>
>>>    What's sff sans bmdma?
>>
>> Supposed to be TF interface.  IIRC, the SFF term was first from Alan 
>> although it's entirely possible that I misunderstood it and used it in 
>> the wrong way.  Alan, can you please clear up the confusion?
> ..
> 
> SFF stands for "Small Form Factor", as in the "SFF Committee Information
> Specification for Bus Master Programming Interface for IDE ATA 
> Controllers Rev 1.0"
> from May 16, 1994.
> 
> That document is basically a committee rubber-stamp of the earlier Intel
> "PCI IDE Controller Specification Revision 1.0" dated 3/4/94.

Ah.. that means we have the whole naming thing wrong.  Yewwww....

-- 
tejun
