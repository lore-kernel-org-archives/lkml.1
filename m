Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbXFOPkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbXFOPkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXFOPkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:40:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:26820 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXFOPkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pFA0vF3XT1dDKePlYKKaBgDbBpLi3PzMad29P2bn979DRIIk/Q91wAsyjTKviXAgETMwEGCbIuptT+IcziX90l2Hpa9pkeCJy2ix8ZXj3cLEv1/QmyJNyvd81F7mPa6tnCuLqeCAqNPi0XrU5eNwsE2CUJxfohORbLIU3nN3E3M=
Message-ID: <4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com>
Date: Fri, 15 Jun 2007 23:39:59 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: How to printk unsigned long long variable?
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070615083355.f5bdb784.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
	 <19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
	 <20070615083355.f5bdb784.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks all.
Is this right?
        dev->dev.dma_mask = bus->controller->dma_mask;
        printk(KERN_ERR "hey,jason,see,dma_mask is
%llu\n",*(dev->dev.dma_mask));


On 6/15/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Fri, 15 Jun 2007 17:04:00 +0200 Vegard Nossum wrote:
>
> > On 6/15/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> > > typedef unsigned long long u64;
> > > u64             *dma_mask;
> > > Then how to use printk() to print out a dma_mask variable?
> >
> > In regular printf(), this would be specified by the format "%llu". Try that?
>
> and cast dma_mask to (unsigned long long), at least in kernel printk()
> calls.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
