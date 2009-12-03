Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZLCTki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZLCTki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZLCTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:40:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35956 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbZLCTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jq73oDfADp80t84vDTWr6KeXS/ZPXuTovhQCTOuEhXxc0GS6BaBmnvWA4o8uHtg4XW
         tB3nheH1YzJCtLw7Nj4g/OtbVR6rez5iAookDkkFydLfwrGbBDNTVc4iOpqx+v6EE1EL
         EZvR/4b4YaE7rgNMFC+anAA/U+OPhjjILBsBQ=
Message-ID: <4B181436.90008@garzik.org>
Date: Thu, 03 Dec 2009 14:40:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: What's in libata-dev.git?
References: <20091203075653.GA30612@havoc.gtf.org> <200912031647.26342.bzolnier@gmail.com> <4B180E04.5030405@garzik.org> <200912032020.16608.bzolnier@gmail.com>
In-Reply-To: <200912032020.16608.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 02:20 PM, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 03 December 2009 08:14:12 pm Jeff Garzik wrote:
>> On 12/03/2009 10:47 AM, Bartlomiej Zolnierkiewicz wrote:
>>> ( Jeff, you probably would want to take ide-pci-generic fix to your tree
>>>     as libata-dev tree currently breaks build for IDE tree. )
>>
>> I didn't know that.
>
> You would know if you would be either:
>
> 	a) reading
>
> or
>
> 	b) building
>
> patches that you're applying.

Strange that I do both.

But still...  <looks>  ah, I had disabled the *generic drivers in the 
kernel build, and missed a missing comma.  Fixed and rebased #upstream.

	Jeff



