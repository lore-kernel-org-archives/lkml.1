Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbXGTLil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbXGTLil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXGTLhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:37:32 -0400
Received: from [212.12.190.239] ([212.12.190.239]:33102 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545AbXGTLh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:37:27 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-raid@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:24 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707200813.03553.a1426z@gawab.com> <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
In-Reply-To: <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707201429.24594.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> >On 7/20/07, Al Boldi <a1426z@gawab.com> wrote:
> > As always, a good friend of mine managed to scratch my partion table by
> > cat'ing /dev/full into /dev/sda.  I was able to push him out of the way,
> > but
>
> /dev/null ?
>
> > at least the first 100MB are gone.  I can probably live without the
> > first partion, but there are many partitions after that, which I hope
> > should easily be recoverable.
> >
> > I tried parted, but it's not working out for me.  Does anybody know of a
> > simple partition recovery tool, that would just scan the disk for lost
> > partions?
>
> The best way is to backup you partition table before destroyed.

Very true! 

# sfdisk -d 

is a real saviour.  But make sure you don't save it on the same disk you are 
trying to recover.


Thanks!

--
Al

