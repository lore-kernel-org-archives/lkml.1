Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZIVQjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZIVQjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZIVQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:39:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:52963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZIVQjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:39:07 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Raistlin <raistlin@linux.it>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253625878.6575.34.camel@desktop>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:38:53 +0200
Message-Id: <1253637533.18939.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 06:24 -0700, Daniel Walker wrote:
> On Tue, 2009-09-22 at 12:30 +0200, Raistlin wrote:
> > Hi Peter, Hi all,
> > 
> >     this is the implementation of a new scheduling class called 
> >     SCHED_EDF made by me and Michael Trimarchi (CC:-ed). We followed the
> >     suggestions you gave us at the multicore workshop in Kaiserlsautern
> >     on October.
> > 
> > For other people: it is a real-time scheduling policy based on the
> > Earliest Deadline First (EDF) algorithm, one of the most common
> > real-time scheduling algorithms.
> 
> You've got some type of encoding corruption in your patch,
> 
> +       else {
> +               if (!edf_task(p))
> +                       p->sched_class =3D &fair_sched_class;
> +               else
> +                       p->sched_class =3D &edf_sched_class;
> +       }
> =20
>         p->prio =3D prio;
> =20
> 
> See the =20 , and =3D above.. I'm not sure exactly how that gets into
> patches ;(

Daniel, welcome to my kill-file.

