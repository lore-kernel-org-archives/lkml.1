Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZIVXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZIVXi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZIVXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:38:57 -0400
Received: from vena.lwn.net ([206.168.112.25]:49704 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbZIVXiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:38:55 -0400
Date: Tue, 22 Sep 2009 17:39:16 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
Message-ID: <20090922173916.257dff1d@tpl.lwn.net>
In-Reply-To: <1253625878.6575.34.camel@desktop>
References: <1253615424.20345.76.camel@Palantir>
	<1253625878.6575.34.camel@desktop>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 06:24:38 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

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

I could swear we talked about quoted-printable before.  You really need
a new mailer.  Even evolution (which you seem to be using) should
really be able to handle this.

jon
