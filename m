Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbXB0E15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbXB0E15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXB0E14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:27:56 -0500
Received: from ns.miraclelinux.com ([219.118.163.66]:47012 "EHLO
	mail01.miraclelinux.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490AbXB0E1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:27:55 -0500
X-Greylist: delayed 1621 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 23:27:55 EST
Date: Tue, 27 Feb 2007 13:03:05 +0900 (JST)
Message-Id: <20070227.130305.424251739.hyoshiok@miraclelinux.com>
To: riel@redhat.com
Cc: davej@redhat.com, harlan@artselect.com, nickpiggin@yahoo.com.au,
       l_allegrucci@yahoo.it, linux-kernel@vger.kernel.org, mingo@elte.hu,
       suparna@in.ibm.com, jens.axboe@oracle.com, hyoshiok@miraclelinux.com
Subject: Re: SMP performance degradation with sysbench
From: Hiro Yoshioka <hyoshiok@miraclelinux.com>
In-Reply-To: <45E37EA3.3060101@redhat.com>
References: <20070226223645.GA24174@redhat.com>
	<98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
	<45E37EA3.3060101@redhat.com>
X-Mailer: Mew version 3.3 on XEmacs 21.4.13 (Rational FORTRAN)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: Rik van Riel <riel@redhat.com>
> Hiro Yoshioka wrote:
> > Howdy,
> > 
> > MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
> > http://ossipedia.ipa.go.jp/capacity/EV0612260303/
> > (written in Japanese but you may read the graph. We compared
> > 5.0.24 vs 5.0.32)
snip
> > MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
> > machine.
> > 
> > I think there are a lot of room to be inproved in MySQL implementation.
> 
> That's one aspect.
> 
> The other aspect of the problem is that when the number of
> threads exceeds the number of CPU cores, Linux no longer
> manages to keep the CPUs busy and we get a lot of idle time.
> 
> On the other hand, with the number of threads being equal to
> the number of CPU cores, we are 100% CPU bound...

I have a question. If so, what is the difference of kernel's
view between SMP and CPU cores?

Another question. When the number of threads exceeds the number of
CPU cores, we may get a lot of idle time. Then a workaround of
MySQL is that do not creat threads which exceeds the number
of CPU cores. Is it right?

Regards,
  Hiro
--
Hiro Yoshioka
CTO/Miracle Linux Corporation
http://blog.miraclelinux.com/yume/
