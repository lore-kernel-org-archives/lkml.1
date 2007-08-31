Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXHaXN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXHaXN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 19:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXHaXNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 19:13:48 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:35138 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbXHaXNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 19:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CugO8J0ybeJ3t+co+U60MHqDmOgQJV6NqwC+BUjXOqZsN2VfInlViex1dDOLfD6tbLo6T7B0zWaLr2aUFvnKIBmRy5qGz+AMEndBnRI6gLmxESb1oNfYlq9fPwq6MQ5RE+p+NJb0P50zFvPHLirZhK3UOMGxZLBOEkhILRUS2YA=
Message-ID: <6bffcb0e0708311613h59430eado425c95569c21d0cf@mail.gmail.com>
Date: Sat, 1 Sep 2007 01:13:45 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: [ANNOUNCE] DeskOpt - on fly task, i/o scheduler optimization
Cc: LKML <linux-kernel@vger.kernel.org>, "CK Mailinglist" <ck@vds.kolivas.org>
In-Reply-To: <46D895AE.8060308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D8354A.3030208@googlemail.com> <46D895AE.8060308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2007, Chris Snook <csnook@redhat.com> wrote:
> Michal Piotrowski wrote:
> > Hi,
> >
> > Here is something that might be useful for gamers and audio/video editors
> > http://www.stardust.webpages.pl/files/tools/deskopt/
> >
> > You can easily tune CFS/CFQ scheduler params
>
> I would think that gamers and AV editors would want to be using deadline
> (or maybe even as), not cfq.  How well does it work with other I/O
> schedulers?

Actually it does not support other i/o schedulers (early stage of
development ;).

"Linux supports io scheduling priorities and classes since 2.6.13 with
the CFQ io scheduler." (ionice man page)

So we can only tune
antic_expire  est_time  read_batch_expire  read_expire
write_batch_expire  write_expire
for anticipatory and
fifo_batch  front_merges  read_expire  write_expire  writes_starved
for deadline.

I'll have a look on it.

>
>         -- Chris
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
