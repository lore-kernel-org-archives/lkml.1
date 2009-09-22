Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZIVXzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZIVXzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZIVXzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:55:46 -0400
Received: from fifo99.com ([67.223.236.141]:40838 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbZIVXzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:55:44 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Daniel Walker <dwalker@fifo99.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <20090922173916.257dff1d@tpl.lwn.net>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop>  <20090922173916.257dff1d@tpl.lwn.net>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 16:55:39 -0700
Message-Id: <1253663739.4317.12.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 17:39 -0600, Jonathan Corbet wrote:
> On Tue, 22 Sep 2009 06:24:38 -0700
> Daniel Walker <dwalker@fifo99.com> wrote:
> 
> > You've got some type of encoding corruption in your patch,
> > 
> > +       else {
> > +               if (!edf_task(p))
> > +                       p->sched_class =3D &fair_sched_class;
> > +               else
> > +                       p->sched_class =3D &edf_sched_class;
> > +       }
> > =20
> >         p->prio =3D prio;
> > =20
> 
> I could swear we talked about quoted-printable before.  You really need
> a new mailer.  Even evolution (which you seem to be using) should
> really be able to handle this.

We did .. It's not my mailer, it's my scripts .. I read a little of
wikipedia on this and it says it's a MIME encoding..

http://en.wikipedia.org/wiki/Quoted-printable

So it's like a mime encoded patch instead of plain ascii encoded
patch .. I don't think we should all have to parse this stuff out, we
should just be getting utf8 encodings which covers everything we use in
the kernel AFAIK ..

Daniel

