Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbXBUGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbXBUGYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 01:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbXBUGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 01:24:22 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:37094 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXBUGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 01:24:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RpGjE/ojzmLxhBRCF8Rf6YbBPNqqjWMds0a60RGIpiRaOEflHqdvhFbZ58RmnKBHG7dNMlYkJgPCiaa+lA742tYLrZQFoNdOthk1DbkZPZIGSUiWoYuwmW9D99INfFbnBVvCMplaH1PGmDzZcbz3UQZ6TOh10yDNSJ4RDmlAaM4=
Message-ID: <d72aa1340702202224i209fb131pb0f9c2c9cc547e6d@mail.gmail.com>
Date: Wed, 21 Feb 2007 01:24:20 -0500
From: "Marcus Haebler" <haebler@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: SATA problems
Cc: "Pablo Sebastian Greco" <lkml@fliagreco.com.ar>,
       linux-kernel@vger.kernel.org
In-Reply-To: <d72aa1340702202157l1932b393k36cb58ecfbe40178@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <459A674B.3060304@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>
	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com>
	 <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>
	 <45D731A8.90604@fliagreco.com.ar> <45DB0717.90507@gmail.com>
	 <d72aa1340702201655o78975cc7vd67c82eea92bd519@mail.gmail.com>
	 <45DBC2CE.6040408@gmail.com>
	 <d72aa1340702202157l1932b393k36cb58ecfbe40178@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

I checked out the kernel 2.6.19 to 2.6.20 Changelog. Seems like you
fixed a problem with the JMB363. The Asus P5B-Deluxe I am using has a
JMB363 - besides an Intel ICH8R - with the SATA ports set to AHCI as
well. Looks like that might have been the source of the problem in
2.6.19.

Thanks,

Marcus

On 2/21/07, Marcus Haebler <haebler@gmail.com> wrote:
> Tejun,
>
> thanks. In preparation of your patch I installed a vanilla 2.6.20.1
> kernel on my FC6
> system. Amazingly the problem went away with the vanilla(!) kernel and NCQ
> is enabled at boot time (queue_depth is 31). I guess I should have
> tried that kernel
> earlier.
>
> The patches you sent earlier apply w/o problems against the 2.6.20.1
> vanilla kernel
> which is expected. I will test drive those patches tomorrow.
>
> BTW thanks for saving me the 'cat' on the 3 patches. ;)
>
> Thanks,
>
> Marcus
