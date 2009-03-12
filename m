Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZCLBpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZCLBpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZCLBpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:45:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:34177 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZCLBpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YAyihMoF2ZrxXGTjlFK+w3xJcBJ73L6a7aLP/6Z0bJF6SFGWS4wZ98haYPN9GRmTWg
         CDWby9alh9VAkZog3T6XmbZ1CBOTp9KofRV4bZfqxmFrYFzBFtYCudI/6Na8OvY4Qj+z
         mVo16Hu5DdXANhiUjxR7SY3RC4Xt5YKYohGmc=
MIME-Version: 1.0
In-Reply-To: <49B7C907.6030209@mnementh.co.uk>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	 <20090311125928.1563.26784.sendpatchset@rx1.opensource.se>
	 <49B7C907.6030209@mnementh.co.uk>
Date: Thu, 12 Mar 2009 10:45:12 +0900
Message-ID: <aec7e5c30903111845yd5815b0r7b9338106b586b20@mail.gmail.com>
Subject: Re: [PATCH 05/05] tmio_mmc: Support multiple interrupts
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 11:21 PM, Ian Molton <ian@mnementh.co.uk> wrote:
> Magnus Damm wrote:
>>
>> From:  Magnus Damm <damm@opensource.se>
>>
>> Add support for tmio_mmc hardware configurations with
>> multiple interrupts. With this patch applied all interrupts
>> passed as platform data will be used by the driver.
>
> What is this patch intended to support?

I'll make sure you get CC:ed on the platform data patch later on. =)

The hardware has up to four interrupts assigned to the mmc block.
Since I have no documentation at all I'm not sure which interrupt line
is used for what, but after a bit more testing this morning it seems
like one of 4 is enough to get this driver working. I guess the other
interrupts are used for hotplug.

So please ignore this patch for now. Thanks.

/ magnus
