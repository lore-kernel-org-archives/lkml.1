Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885Ab0AVUPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0AVUPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819Ab0AVUPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:15:06 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33961 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab0AVUPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kapVglIenjEWe7f76nME7vDXiMDKKxj2/BS57qDP63bszGy6upmtqgufW/hyegLrAO
         vCSLDI/dOsFurnsf9e8AMBW94LELjCmXQYbCi3HbVfIKkbTAvepkpTA+nzwNQ6TTZ6h0
         /SnjVqqTuKgY4mIZiAMum0APQ1FTLNf61/YKs=
From: Luca Zini <luca.zini@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
Date: Fri, 22 Jan 2010 21:15:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-mio; KDE/4.3.4; x86_64; ; )
Cc: aagaande@gmail.com, rdelcueto@hotmail.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
References: <201001211258.23499.luca.zini@gmail.com> <20100121215438.GK17684@ldl.fc.hp.com> <1264144758.8074.22.camel@marge.simson.net>
In-Reply-To: <1264144758.8074.22.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001222115.00707.luca.zini@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vanilla 33-rc5 runs ok:
with nice set to -20
real    0m8.649s
user    0m8.600s
sys     0m0.030s


with nice set to 19:
real    0m8.658s
user    0m8.600s
sys     0m0.040s

thank you!
	Luca


On Friday 22 January 2010 08:19:18 am Mike Galbraith wrote:
> > if I run a cpu intensive process with the lowest priority (19
> > from man nice) I obtain much better performance that with the
> > highest priority available (-20 from man nice).
> >
> > For example the same file is processed by lame in 8.7 seconds
> > at the lowest priority, and in 12 seconds at the highest
> > priority.  Before posting a bug I wold like to understand if
> > this is a problem related to the i7 mobile (my processor is a
> > i7 Q720).
> >
> > As far as I tested on the same laptop series (dell studio 15),
> > with the same kernel this problem does not exists.
> 
> So you only see this on the i7.  That's odd.  Can you try 33-rc5?
> 
> Posting a reliable reproducer would be nice.  It'd also be nice to see
> what all is running when you see this, and where.
> 
> 	-Mike
> 
