Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZISAHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZISAHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 20:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZISAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 20:07:10 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:41013 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZISAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 20:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Mf6ewABjuCsz1ODpZVns+s/3/Mmn7CfzhTA9eRWbKKGCIB37tOqmpEO5UscByvzKIo
         vX54uoOiXCjK7LJPX4C/ATfDoiBND9vz6W4U8wRlRYg5QGMH++l0xusAi/Dt8dgsMg/t
         EIAtuY0gWl3Io5rN5fCuTAgaKCl7kIl+6hSng=
MIME-Version: 1.0
In-Reply-To: <20090918163927.GA365@core.coreip.homeip.net>
References: <4A5BF6F0.6020403@samsung.com>
	 <20090714082452.GH2822@dtor-d630.eng.vmware.com>
	 <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com>
	 <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com>
	 <002b01ca046c$7f9fd240$7edf76c0$%szyprowski@samsung.com>
	 <5d5443650907140323l6cc06151nbec94d5d8646c60a@mail.gmail.com>
	 <003f01ca051c$0e8d12b0$2ba73810$%szyprowski@samsung.com>
	 <20090916085749.GL2756@core.coreip.homeip.net>
	 <4AB3416F.6010004@samsung.com>
	 <20090918163927.GA365@core.coreip.homeip.net>
Date: Sat, 19 Sep 2009 09:07:11 +0900
Message-ID: <4e1455be0909181707w113015ddk90e4b74cfb0c462f@mail.gmail.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
From: Joonyoung Shim <dofmind@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Trilok Soni <soni.trilok@gmail.com>, Kim Kyuwon <q1.kim@samsung.com>,
       Kim Kyuwon <chammoru@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/19 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Joonyoung,
>
> On Fri, Sep 18, 2009 at 05:14:39PM +0900, Joonyoung Shim wrote:
>>
>> Hi, Dmitry.
>>
>> I tested your patch with threaded IRQ. Because the interrupt of the
>> MAX7359 device is the low level detecting, i should add the IRQF_ONESHOT
>> flag on request_threaded_irq(). If it is added IRQF_ONESHOT flag, the it
>> operates well.
>
> Thank you for testing.
>
>> Do you want i send the patch?
>
> No, I fixed it locally. I took the liberty of marking the patch as
> "Tested-by" you, I hope you don't mind.
>

OK. Thanks.

-- 
- Joonyoung Shim
