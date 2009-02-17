Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZBQXMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZBQXMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZBQXLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:11:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:56653 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZBQXLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AvJYCucx3G43k1ONLeKp0swjjLI9OWKf+eT5+IkLp1qaFJHzp2eovzBJ8YlvRWxhq8
         BNyDZQn1kODePEOFcHx/btb69J2pr/aTj++pTLuIhReUcv2Wth6Bs7frKF0TBZvVKp71
         rcGVn2pa4bkfB8HAp3iXgEi7Wv/mKt33Mtu9c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	 <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
	 <20090217230050.GG16841@parisc-linux.org>
	 <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
Date: Tue, 17 Feb 2009 15:11:50 -0800
X-Google-Sender-Auth: 1910c6c1985b6776
Message-ID: <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
Subject: Re: mpt fusion broken sometime since 2.6.24
From: Yinghai Lu <yinghai@kernel.org>
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 3:07 PM,  <david@lang.hm> wrote:
> On Tue, 17 Feb 2009, Matthew Wilcox wrote:
>
>> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>>>
>>> I got a picture of the failed boot at
>>> http://linux.lang.hm/linux/IMG00052.jpg
>>
>> The PCI-MSI line is probably indicative.  Can you try booting with:
>>
>> mptbase.mpt_msi_enable_sas=0
>>
>> and also send us an lspci -v so we can update the blacklist?
>
> is that disabling SAS for this system? if so, that's the wrong thing to do
> (the drives are SAS)
>
it only disable MSI with that mptsas.
and mptsas will use ioapic routing.

can you post whole bootlog?

YH
