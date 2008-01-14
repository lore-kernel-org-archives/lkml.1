Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYANGwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYANGwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYANGwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:52:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:1558 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYANGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hpLBG+Rhgm6zSe/LJQiZghZ7ceBuwnf36orCR6I5RCUmyPy/wd0omoosnmhs0vWjFmqGXEAmt5HUjlxq+lSipbEkaoCEAJ8KmoTvPkiwxUG2eAN+YEZvZ1TGhHjPcFEy0Q7PakCqEfx0/pQCNPpUPYyoqDZ1q8KkwqeDIg9Flo4=
Date: Mon, 14 Jan 2008 07:58:21 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Message-ID: <20080114065821.GA1643@ff.dom.local>
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com> <20080112201111.GA8129@ami.dom.local> <a8e1da0801131736i4fa2eed7pd1569ed1b6214510@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801131736i4fa2eed7pd1569ed1b6214510@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 09:36:04AM +0800, Dave Young wrote:
> On Jan 13, 2008 4:11 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
...
> > Probably some tiny oversight, but I see this comment to struct class
> > doesn't mention devices list, so maybe this needs to be updated BTW?:
> >
> > (from include/linux/device.h)
> > "        struct semaphore        sem;    /* locks both the children and interfaces lists */"
> 
> Sorry for my lazy, I think so too.
> IMHO, it should be updated after the comments.

As a matter of fact, only later I've found this question is 'fixed' in
7/7. But, actually, I was more concerned if this patch changed the
'official' policy of this sem (then it would be nice to mention about
this in a changelog) or this comment was simply incomplete.

Thanks,
Jarek P.
