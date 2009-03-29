Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZC2JdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZC2JdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZC2Jc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:32:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:53007 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZC2Jc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kmgmpIm6dtUHOXFLGzo+sAiH7T4ZWdd1pHypGf/GOk5Z+reapsuTmFlc1NIp4BeZ5W
         qQ7QowLaQxsWEb8OZ9NURb9kI3K/wCDe/OWZ1b07RrQbrSn3h4g4TVbn/7gCDPi0XLOE
         BAgcZiry9QGd0QbS0fc9WbQ9GquYIVOjJaG0M=
MIME-Version: 1.0
In-Reply-To: <200903291115.54351.prakash@punnoor.de>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	 <200903282316.55142.prakash@punnoor.de> <49CECFCF.8060403@kernel.org>
	 <200903291115.54351.prakash@punnoor.de>
Date: Sun, 29 Mar 2009 02:32:56 -0700
X-Google-Sender-Auth: 35f7c7eabb0c5b23
Message-ID: <86802c440903290232g293b72e5oa05c20121bbc16d9@mail.gmail.com>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
From: Yinghai Lu <yinghai@kernel.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 2:15 AM, Prakash Punnoor <prakash@punnoor.de> wrote:
> On Sonntag 29 März 2009 03:33:03 Yinghai Lu wrote:
>> please try follwing patch over pci/linux-next
>>
>> Thanks
>>
>> YH
>>
>> [PATCH] pci: don't enable too much HT MSI mapping -v6
>
> Works fine now, thanks!
>
> pci 0000:00:00.0: Found disabled HT MSI Mapping
> pci 0000:00:00.0: Enabling HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:05.0: Boot video device
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0e.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0f.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.1: Enabling HT MSI Mapping
>

can you put you pcie network card in the pcie slot belong to c51?
we should find 00:03.0 the pcie bridge...

Thanks

YH
