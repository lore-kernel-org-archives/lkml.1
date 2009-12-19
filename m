Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZLSWzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZLSWzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZLSWzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:55:22 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33930 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZLSWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:55:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MBeD/Rz4BmzWn+m7VKyh7nwiGXnf5YCGxitaY+EMbc2KywulnZv7KSF99YwVknE2mA
         75R1MWRfl2tXD/BxjlwBzZvMPT2DVXriLpUsWZfgpmBHA8wwQfRud+ia7ZJOT0yGhgZS
         6YF9eLAO83Nxik8Dm3fn2N3FIUzMLX37TPf9Y=
Message-ID: <4B2D59D6.30008@garzik.org>
Date: Sat, 19 Dec 2009 17:55:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Cui <cuicui@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32 seemed to have broken nVidia MCP7A sata controller
References: <7c8826910912182213o2e0e8af7ic305f150c52e0618@mail.gmail.com>	 <4B2C80DD.9080005@garzik.org> <4B2D1CF3.4070106@gmail.com> <7c8826910912191437k4e1d93bap12874a6d6e0046d3@mail.gmail.com>
In-Reply-To: <7c8826910912191437k4e1d93bap12874a6d6e0046d3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 05:37 PM, Mike Cui wrote:
> Thanks, changing that one line fixed it. I can try to find an intel
> motherboard sometime next week to see if it's the drive or the
> controller.
>
> On Sat, Dec 19, 2009 at 10:35 AM, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> Mike, can you try and revert that patch, or else just change this line in
>> drivers/ata/ahci.c:
>>
>>                 pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
>>
>> to
>>
>>                 pi.flags |= ATA_FLAG_NCQ;
>>
>> and rebuild and see if it works better?


Thanks for that confirmation.  And yeah, it would definitely help if we 
can narrow that down to either the drive or the controller.

	Jeff



