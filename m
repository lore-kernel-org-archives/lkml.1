Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0AUQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0AUQuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726Ab0AUQuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:50:18 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39804 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0AUQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BjsQfLI2E5eeG1I2aaEp+cGkTE5ABnnO1Q/L+XTMJADhF5V/wBO94dHHpNKTlX4nqE
         FxEWecnhoWZ8123G4mq2NevKAxObMADvLOfuwJ0RbNkXtdAzlaGLzQ8dqwN4Q0aZL4VL
         FzSyHD0h28KTf/0WOd31Jf963EQrudMbgAyGo=
Message-ID: <4B5885C5.1010607@garzik.org>
Date: Thu, 21 Jan 2010 11:50:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/64] pata_atiixp: remove superfluous wrapper function
References: <20100118171349.14623.90030.sendpatchset@localhost> <4B57D2E4.30203@garzik.org> <4B57D365.3040201@garzik.org> <201001211223.16924.bzolnier@gmail.com>
In-Reply-To: <201001211223.16924.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 06:23 AM, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 21 January 2010 05:09:09 am Jeff Garzik wrote:
>> On 01/20/2010 11:07 PM, Jeff Garzik wrote:
>>> On 01/18/2010 12:14 PM, Bartlomiej Zolnierkiewicz wrote:
>>>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>>> Subject: [PATCH] pata_atiixp: remove superfluous wrapper function
>>>>
>>>> Fix documentation for ->set_[pio,dma]mode methods while at it.
>>>>
>>>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>>> ---
>>>> drivers/ata/pata_atiixp.c | 29 +++++++----------------------
>>>> 1 file changed, 7 insertions(+), 22 deletions(-)
>>>
>>> applied
>>
>> undone...  it broke the build, presumably because it requires something
>> in your tree that's not in libata-dev.git
>
> Jeff, as noted in the first mail those patches are against atang tree
> (which has many changes which are missing from your libata-dev tree)..

Yes, hence "presumably because it requires something in your tree"

Would you be willing to submit a push against the latest 
libata-dev.git#upstream?

	Jeff




