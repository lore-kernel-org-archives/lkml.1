Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbYCJHri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbYCJHri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYCJHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:47:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:48033 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYCJHr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sCeKp/DHcqXqurBedA+aya5n5+rJvxrVbhU78YLSrg+Qu8eLrbnilYBL9HLUlX4NpQncu+J1XTnx6B+oUIpYofVSg0BlgsnJY3prAfNwRaWK0ELQXn+o37imXFDOppSYBcbe9/OAC7UorF7A6094pgRq60Yh1eB8eKjeqospqtw=
Message-ID: <47D4E78A.10507@gmail.com>
Date: Mon, 10 Mar 2008 16:47:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on
 pata_ali
References: <200803082246.47987.rjw@sisk.pl> <20080309073824.902DC82CF2E@smtp04.mtu.ru> <200803100012.27520.rjw@sisk.pl> <47D4E64F.5070106@gmail.com>
In-Reply-To: <47D4E64F.5070106@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Rafael J. Wysocki wrote:
>>>> where ata1 is:
>>>>
>>>> scsi0 : pata_ali
>>>> scsi1 : pata_ali
>>> Oh, is it only with audio CDs? I am unable to use DVD on pata_ali in DMA at
>>> all. Have you tried to disable ATAPI DMA (libata.dma=1)?
>> Data CDs seem to work fine here.
> 
> * Does booting into runlevel 1, putting in an audio cd and running
> cdparanoia give the same result?
> 
> * Does setting module parameter libata.force to "1.00:pio4" make any
> difference?

Oh, never mind.  I have a hunch.  I'll report back in a while.

-- 
tejun
