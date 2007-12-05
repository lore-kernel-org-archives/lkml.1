Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXLEHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXLEHqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXLEHqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:46:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:35032 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXLEHqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KgOwps4WAT+Yh9VpDXWgfFz0NpGX3WAoGwEnVb0cnQ3dzm+6CWCL1fOYWJgbGaKrp9McNi8Gy3Iu5ZHcNHLN8kZZ/h4KWE68ku4luwq21KNpG2C7EAvDPpfjT+wGPRJRlW9pezl3NPPjUiyDPxCAF3Jm2ruWx44pfhBHZThieFw=
Message-ID: <47565738.1050003@gmail.com>
Date: Wed, 05 Dec 2007 16:46:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kjartan Maraas <kmaraas@broadpark.no>
CC: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com> <1196253340.2884.1.camel@localhost.localdomain> <474FE862.4040700@gmail.com> <1196458627.4106.1.camel@localhost.localdomain>
In-Reply-To: <1196458627.4106.1.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kjartan Maraas wrote:
> fr., 30.11.2007 kl. 19.39 +0900, skrev Tejun Heo:
>> Kjartan Maraas wrote:
>>> on., 28.11.2007 kl. 10.09 +0900, skrev Tejun Heo:
>>>> Kjartan Maraas wrote:
>>>>> I get this exact error message on a normal first time boot here. I'm
>>>>> using the latest fedora development kernel which is 2.6.24-rc2-git6
>>>>> based. And I have the latest BIOS from HP IIRC.
>>>>>
>>>>> This is an HP nc6400 intel based laptop:
>>>> Care to post boot dmesg?  Or does harddisk detection fail because of this?
>>>>
>>> Here you go. It shows the error two times and then it gets it right and
>>> continues to boot. No other problems arise from this that I can see.
>> I'm attaching two patches.  Please apply each on top of clean 2.6.24-rc3
>> and report kernel boot logs for both.
>>
> I tried to do that but recent kernels hang on boot here after TSC:
> clocksource installed.
> 
> Filed a bug here:
> https://bugzilla.redhat.com/show_bug.cgi?id=405721
> 
> but it also happens on the plain rc3 kernel...

Can you please give a shot at -rc4 kernel?

-- 
tejun
