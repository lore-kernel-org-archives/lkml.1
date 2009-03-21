Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZCUWxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZCUWxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZCUWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:53:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:28941 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZCUWxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p8c38VMINGe865t+yiOE5ueakj+HN98l8z+qdpkfuodjSsdGoQaaiJMOop1oA59W7/
         hHCxVcMLAY4jkD4pXp2E2rBYgUcUMV0Ek5yWQkkKTWPL+FHWYqMxmKTfbIs3hxkJ+fcG
         l/hfyS5ZfPBDaGn+A4ZBaMeXFeQi64PtjnX90=
MIME-Version: 1.0
In-Reply-To: <49C56D74.3030303@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com>
	 <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
	 <49C56D74.3030303@emcraft.com>
Date: Sat, 21 Mar 2009 15:53:38 -0700
X-Google-Sender-Auth: 342e586ea498fa2b
Message-ID: <e9c3a7c20903211553w5200ea0cu360d0a57fef77c66@mail.gmail.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 
	multiplication
From: Dan Williams <dan.j.williams@intel.com>
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com,
       Yuri Tikhonov <yur@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 3:43 PM, Ilya Yanok <yanok@emcraft.com> wrote:
> Hi Dan,
>
> Dan Williams wrote:
>>> Have you ever tested this code path?
>>>
>>
>> Not this path, not yet.
>
> You can disable the fallback to optimized synchronous functions and test
> it with raid with dmaengine disabled. Or you can add support for
> arbitrary coefficients in dmatest...

There are also corner cases with channel switching that can only be
tested with an async_tx specific test module and coordination from the
driver.

>>   Which is exactly why I am holding back the md
>> pieces.  We can collaborate on testing and stabilizing the api for a
>> kernel cycle before turning on the raid6 conversion.
>>
>
> Unfortunately we are not getting paid for this project any more so I
> can't spend much time on it.

Hopefully I can occasionally call on you to try out some tests with
ppc440spe driver and hardware?  As we have seen in the past that
platform hits corner cases that iop13xx does not.

Thanks,
Dan
