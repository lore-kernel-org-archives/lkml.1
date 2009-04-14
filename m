Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZDNHne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZDNHne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZDNHnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:43:21 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:59594 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZDNHnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MNEijnhft7sBkBlB9CFvEG4lB3LnlCTF0DH1WTKxWbz8BRzJSLN9vM2qJFGbzBlOQs
         XRzyZInpbnCA7EFSJuse/SvAS4dE4b5ANhGzqjP2uRQBQA7SqchcqnAxCEi7Icbr8GGd
         CmYcnH1vxEaLWI4OuGF1lbtJhD8yzOmcUzWxg=
MIME-Version: 1.0
In-Reply-To: <20090413.162248.60285999.davem@davemloft.net>
References: <20090404.170539.148727646.davem@davemloft.net>
	 <cb0375e10904042100o1a203512l593021ee66cb591d@mail.gmail.com>
	 <alpine.WNT.2.00.0904091128270.6048@jbrandeb-desk1.amr.corp.intel.com>
	 <20090413.162248.60285999.davem@davemloft.net>
Date: Tue, 14 Apr 2009 00:43:19 -0700
X-Google-Sender-Auth: ff0741fc8eaf7331
Message-ID: <9929d2390904140043v4fa34f6cj2c9ebad3ce1f9894@mail.gmail.com>
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: jesse.brandeburg@intel.com, amluto@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 4:22 PM, David Miller <davem@davemloft.net> wrote:
> From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
> Date: Thu, 9 Apr 2009 17:48:04 -0700 (Pacific Daylight Time)
>
>> Dave, if we move the netif_carrier_off call to our dev->open like tg3 has,
>> do you think this is sufficient?
>
> Yes.
>
>> e1000e: indicate link down at load
>>
>> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>>
>> same kind of patch as e1000, let driver explicitly push link state
>> once link comes up.
>>
>> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> I'll wait to get this via Jeff Kirsher.
>
> Thanks.
> --

I have added this to my queue and will be sent out with the other
e1000 patch I have,in the next day or two.

-- 
Cheers,
Jeff
