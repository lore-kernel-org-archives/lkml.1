Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZEHCse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZEHCse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZEHCsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:48:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:40415 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZEHCsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ivDY/Ie5MAm29yZlmXgULh38YrN6kH2YSJVqnMO8NnjIBh2//jTAP5Se3zZJRr4Mzl
         1ca8F0SWK9YOCDG58BeMcG+t/vg4KDJdTwj4BSO8DTOydiRouY1+udSHEYToccuoTVh4
         qdsod6rCw5ogfd5EHBgOKs1qOykXoDS3AFidM=
MIME-Version: 1.0
In-Reply-To: <725760.23277.qm@web26207.mail.ukl.yahoo.com>
References: <1212611148.19205.22.camel@lappy.programming.kicks-ass.net>
	 <725760.23277.qm@web26207.mail.ukl.yahoo.com>
Date: Fri, 8 May 2009 11:48:20 +0900
Message-ID: <49b7c2350905071948w37fd3c0ekfdfd0d1009685053@mail.gmail.com>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may 
	have realtime uses)
From: GeunSik Lim <leemgs1@gmail.com>
To: trimarchimichael@yahoo.it
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mark Hounschell <dmarkh@cfl.rr.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Fabio Checconi <fabio@gandalf.sssup.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michael Trimarchi,

Recently, I read your paper about EDF implementation  in Linux  like belows.

http://feanor.sssup.it/~marko/SAC09.pdf
(An implementation of the earliest deadline first algorithm in Linux
Proceedings of the 2009 ACM symposium on Applied Computing. )

Can I get your 2.6.27 based EDF patch to  test your experiment result ?
Thanks reading.


Regards,
GeunSik, Lim


2008/6/5 Michael Trimarchi <trimarchimichael@yahoo.it>:
> [ sorry if this is going OT ]
>
> Hi,
>
>>
>> Furthermore, cpusets allow for isolated but load-balanced RT domains. We
>> now have a reasonably strong RT balancer, and I'm looking at implementing
>> a full partitioned EDF scheduler somewhere in the future.
>>
>
> I'm working on a partitioned EDF scheduler right now, and I have to
> face several issues, starting from the interface to use to expose the
> EDF scheduler to userspace, and the integration with the existing
> sched_rt policy.
>
> By now I'm experimenting with an additional sched_class that implements
> a SCHED_EDF policy, extending the POSIX struct sched_param with the
> EDF parameters of the task, do you see any better way to do that?
> Could that approach be reasonable?
>
> Michael
>
>
>      ___________________________________
> Scopri il Blog di Yahoo! Mail: trucchi, novità, consigli... e la tua opinione!
> http://www.ymailblogit.com/blog/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
