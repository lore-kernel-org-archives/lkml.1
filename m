Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZIRQjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZIRQjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZIRQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:39:34 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35956 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZIRQjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C3DfUnsIIs3m9q2MJD1VQ3IaB0qzR3G49mE2ZwgYW2PbzTnqK8xAEDmV7K58xRvtw4
         sm8DyivTfUgEZaTG5eR8DWQvaAxTaFoU4Q8l24BkuyBgVbuJlLvrrPxrTrAmvjQNHAOf
         NSdoPlwMbMaOBTMtkIl5nFw+MlSn6EgF1WVY0=
Date: Fri, 18 Sep 2009 09:39:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       "'Trilok Soni'" <soni.trilok@gmail.com>,
       "'Kim Kyuwon'" <q1.kim@samsung.com>,
       "'Kim Kyuwon'" <chammoru@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Message-ID: <20090918163927.GA365@core.coreip.homeip.net>
References: <4A5BF6F0.6020403@samsung.com> <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com> <20090714082452.GH2822@dtor-d630.eng.vmware.com> <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com> <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com> <002b01ca046c$7f9fd240$7edf76c0$%szyprowski@samsung.com> <5d5443650907140323l6cc06151nbec94d5d8646c60a@mail.gmail.com> <003f01ca051c$0e8d12b0$2ba73810$%szyprowski@samsung.com> <20090916085749.GL2756@core.coreip.homeip.net> <4AB3416F.6010004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB3416F.6010004@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonyoung,

On Fri, Sep 18, 2009 at 05:14:39PM +0900, Joonyoung Shim wrote:
> 
> Hi, Dmitry.
> 
> I tested your patch with threaded IRQ. Because the interrupt of the 
> MAX7359 device is the low level detecting, i should add the IRQF_ONESHOT 
> flag on request_threaded_irq(). If it is added IRQF_ONESHOT flag, the it
> operates well.

Thank you for testing.

> Do you want i send the patch?

No, I fixed it locally. I took the liberty of marking the patch as
"Tested-by" you, I hope you don't mind.

-- 
Dmitry
