Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYANHA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYANHA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 02:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYANHAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 02:00:17 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:48668 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805AbYANHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 02:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IZky8miTlyHEFs4qOWK4t59ksxo5+TP0qqb7uBJvv57rQIS1mgdFkleNyrNtAbCzY9KVwUE6FGNsHwWghg6K0TlfX4biESgifI1QdyoeBj5isXUpZwPGZ9/jetmB+MichuELxAk2OXx0oyGkC3xNIfN7UG0fBxa2wrr+NHihjPQ=
Message-ID: <a8e1da0801132300y3e567275h96c4a3c9234e201c@mail.gmail.com>
Date: Mon, 14 Jan 2008 15:00:14 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net
In-Reply-To: <20080114065821.GA1643@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <20080112201111.GA8129@ami.dom.local>
	 <a8e1da0801131736i4fa2eed7pd1569ed1b6214510@mail.gmail.com>
	 <20080114065821.GA1643@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 2:58 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Mon, Jan 14, 2008 at 09:36:04AM +0800, Dave Young wrote:
> > On Jan 13, 2008 4:11 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> ...
> > > Probably some tiny oversight, but I see this comment to struct class
> > > doesn't mention devices list, so maybe this needs to be updated BTW?:
> > >
> > > (from include/linux/device.h)
> > > "        struct semaphore        sem;    /* locks both the children and interfaces lists */"
> >
> > Sorry for my lazy, I think so too.
> > IMHO, it should be updated after the comments.
>
> As a matter of fact, only later I've found this question is 'fixed' in
> 7/7. But, actually, I was more concerned if this patch changed the
> 'official' policy of this sem (then it would be nice to mention about
> this in a changelog) or this comment was simply incomplete.

It was just "killed" because I thought it's not true.

I means I will update the correct comment after comments.

>
> Thanks,
> Jarek P.
>
