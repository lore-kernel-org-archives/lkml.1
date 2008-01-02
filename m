Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYABG4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYABG4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYABGzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:55:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:61985 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYABGzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YFWL//uS7tJh2bKWpTKBkMMm218Uyq/D78TDey4KkLfFQc8XAzyijk9MJmLpO3cv1s5JoE0qtDCrYUXL9doeEpD3SG4yuFE02BJvgHaR5Tfd2rkAcCoxwu4Souxkac+ThAR61mpCnQ8Jky9CSYxhm4P7GV0bWGiNHyGWmhqgJDI=
Message-ID: <477B3571.6080500@gmail.com>
Date: Wed, 02 Jan 2008 15:55:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Jeff Garzik <jeff@garzik.org>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kluo@nvidia.com, AMartin@nvidia.com, pchen@nvidia.com
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <477B10F2.9000107@shaw.ca> <477B1233.3090706@gmail.com> <477B2CE4.8070602@garzik.org> <477B318E.4030309@shaw.ca>
In-Reply-To: <477B318E.4030309@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Jeff Garzik wrote:
>> Tejun Heo wrote:
>>> Thanks a lot for the detailed explanation.  Nvidia ppl, any ideas?
>>> FLUSH is used regularly.  We really need to fix this.
>>
>>
>> I reiterate my opinion :)  ...   We should remove ADMA support from
>> sata_nv.  It's only in a few chips, it's not appearing in any new
>> chips, and nasty problems have lingered since ADMA support was
>> introduced.
>>
>> Definitely sounds like we should disable ADMA by default for
>> 2.6.24-rc, too.
> 
> I wouldn't agree.. It's only in a few chips (CK804/MCP04), but those
> chips are very common in desktop, workstation, even some server
> machines. Given the huge number of these chips out there, problem
> reports have been quite rare.

I agree with Jeff here.  Maybe not remove but disable it by default and
when enabling warn loudly.  NCQ just doesn't enough for its cost when
the cost includes erratic behaviors.  Only very small fraction of error
cases actually make to bugzilla or this mailing list.

Nvidia gents, is there anyway (be it NDA or whatever) to get Robert or
any of us technical documentation?

Thanks.

-- 
tejun
