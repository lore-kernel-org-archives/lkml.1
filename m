Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYIVCki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYIVCki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 22:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYIVCka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 22:40:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:18855 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYIVCk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 22:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uo9RHvmlyqDQ6YKvxdZTFEI46Eww4rt5cWPpYo3bdCxTK4T+I2/gsczveSZta8MDz2
         rjCrR+IX3qLqXmH16le4EH5zfTyscEIWs7iDphlhT4NmELEhh+VWb9KRifmuv/C+ftQl
         g3ly/GYDHEfkvYwsxXtLxGubf1wyFV0g87dZk=
Message-ID: <4e5ebad50809211940g4146910o1a36d4a668686009@mail.gmail.com>
Date: Mon, 22 Sep 2008 10:40:28 +0800
From: "Sonic Zhang" <sonic.adi@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: [PATCH][kgdb][v3] Make mem access function weak in kgdb.c and kgdb.h
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "kgdb mailing list" <kgdb-bugreport@lists.sourceforge.net>
In-Reply-To: <48D38D04.8090505@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221529769.15380.10.camel@eight.analog.com>
	 <4e5ebad50809190251s16491edct7754080202790e2c@mail.gmail.com>
	 <48D38D04.8090505@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb patch for blackfin is targeted to the 2.6.28 kernel, because
2.6.27 kernel doesn't accept big changes in this stage.

Sonic

On Fri, Sep 19, 2008 at 7:29 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
>
> One question I had, was if this work was targeted to the 2.6.27 kernel
> or the 2.6.28 kernel.  I figure there are blackfin fin specific patches
> to go in with this, and I can attempt to sync with your blackfin pull
> requests.
>
> Thanks,
> Jason.
>
> Sonic Zhang wrote:
>> Hi Jason,
>>
>> Any comments?
>>
>> Sonic Zhang
>>
>> On Tue, Sep 16, 2008 at 9:49 AM, sonic zhang <sonic.adi@gmail.com> wrote:
>>
>>> L1 instruction memory and MMR memory on blackfin can not be accessed by
>>> common functions probe_kernel_read() and probe_kernel_write().
>>> Blackfin asks for 2/4 byte align access to MMR memory and DMA access to
>>> L1 instruction memory. These functions need to be reimplemented in
>>> architecture specific kgdb.c. Update documentation and prototypes as
>>> well.
>>>
>>> Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
>>>
>
>
