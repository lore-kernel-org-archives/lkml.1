Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZD1BNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZD1BNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZD1BNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:13:43 -0400
Received: from mail-qy0-f180.google.com ([209.85.221.180]:59549 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZD1BNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:13:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I2ed8rur2POrOecfyvdt6tn76IhpAcstb0HbAxRc7rXDek2/dc2n/V7txoQ1Sj2T+a
         5Y+bD9S/b9y6ddGS3yqjXcflksUnefIfgjV6wTi2J6Li+V99IhMaCbgSD4te8vSDGyYJ
         TYUuYywKrorN6wwDOFnU2qnnm0eu2la/4Lnkk=
MIME-Version: 1.0
In-Reply-To: <87d4ax7qf3.fsf@free.fr>
References: <87iqkvp6i3.fsf@free.fr>
	 <1240566136.27410.3291.camel@vega.slimlogic.co.uk>
	 <87d4ax7qf3.fsf@free.fr>
Date: Tue, 28 Apr 2009 09:13:41 +0800
Message-ID: <f17812d70904271813t2c67d929n67c84bb86f450e35@mail.gmail.com>
Subject: Re: Patch to add mioa701 glue for voltage regulation
From: Eric Miao <eric.y.miao@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: eric.miao@marvell.com, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 5:11 AM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Liam Girdwood <lrg@slimlogic.co.uk> writes:
>
>> On Thu, 2009-04-23 at 20:30 +0200, Robert Jarzmik wrote:
>>> Hi Mark and Eric,
>>>
>>> I have that patch which adds voltage regulation definitions to mioa701
>>> board. The trick is, this patch depends on two others :
>>>
>>>  - one which will be merged through Mark's regulator tree.
>>>    This one is mandatory as a compiling dependency exists through include files.
>>>
>>>  - one which will be merge through Eric pxa tree.
>>>    This is the cpufreq one, and has a "very weak" dependency, as only the
>>>    "vcc_core" name _is_ the dependency.
>>>
>>> I think the easiest way to solve the compiling dependency
>>> (include/linux/regulator.max1586.h) is to make that patch go through regulator
>>> tree as well for linux-next, even if it's arm machine specific, don't you ?
>>>
>>
>> If fine with this going through regulator providing I get an ACK from
>> Eric.
>
> Eric,
>
> Since Liam took the max1586 regulator through his tree, would you state if you
> ack that please ?
>

I'd really be happy to. However, my concern is that this patch modifies
arch/arm/mach-pxa/mioa701.c _only_, so it would be better to go through
my tree so that I can manage all the potential merge conflicts. There are
several other changes to mioa701.c and I expect the content in
arch/arm/mach-pxa/* to be heavily changed due to recent addition
of pxa168/pxa910 support.

The issue of dependency, as was always before, can be resolved by
putting this into 'pending' and monitoring the status of merge window
before sending the PULL request.

Liam,

Sounds OK to you?
