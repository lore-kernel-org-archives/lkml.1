Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbYFDVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbYFDVvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbYFDVvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:51:00 -0400
Received: from web26207.mail.ukl.yahoo.com ([217.12.10.244]:29523 "HELO
	web26207.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755232AbYFDVu7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:50:59 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 17:50:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gOWoRLkvBa52w09fFxu3IoZP8+uyOIXxGrC1HWYi74nmnWKzzKMrM/qlVWDPcX/uTEl/WjAugYZ3mfnokwFs5TAelywz4zp0ye6Eftq4APf094jygOgOW/7ainJJExl3MZbWvU5pyx673EirnS80vT4+RhpzgPvBZll7gGzmU60=;
X-Mailer: YahooMailWebService/0.7.199
Date: Wed, 4 Jun 2008 21:44:18 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Reply-To: trimarchimichael@yahoo.it
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
To: Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Oeser <ioe-lkml@rameria.de>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <1212611148.19205.22.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <725760.23277.qm@web26207.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ sorry if this is going OT ]
 
Hi,
 
>  
> Furthermore, cpusets allow for isolated but load-balanced RT domains. We
> now have a reasonably strong RT balancer, and I'm looking at implementing
> a full partitioned EDF scheduler somewhere in the future.
>  
 
I'm working on a partitioned EDF scheduler right now, and I have to
face several issues, starting from the interface to use to expose the
EDF scheduler to userspace, and the integration with the existing
sched_rt policy.

By now I'm experimenting with an additional sched_class that implements
a SCHED_EDF policy, extending the POSIX struct sched_param with the
EDF parameters of the task, do you see any better way to do that? 
Could that approach be reasonable?

Michael


      ___________________________________ 
Scopri il Blog di Yahoo! Mail: trucchi, novità, consigli... e la tua opinione!
http://www.ymailblogit.com/blog/
