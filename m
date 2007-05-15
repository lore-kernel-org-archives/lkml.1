Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXEOWLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXEOWLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXEOWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:10:56 -0400
Received: from www.osadl.org ([213.239.205.134]:46952 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755739AbXEOWKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:10:55 -0400
Subject: Re: [2.6.21.1] OOPS in timer stats code
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4649FDEA.2050703@redhat.com>
References: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl>
	 <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com>
	 <4649FDEA.2050703@redhat.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 00:14:52 +0200
Message-Id: <1179267292.12838.42.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 14:37 -0400, Chuck Ebbert wrote:
> Michal Piotrowski wrote:
> > [Adding Thomas to CC]

Added Ingo as well :)

> > On 15/05/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> >> Hi,
> >>
> >> After an uptime of, say, 4 hours I got an oops on my P4 with HT and
> >> 2GB ram.
> >> It has dynamic ticks enabled as well has timer stats. I cannot reboot the
> >> machine to give more details right now (19:00 gmt+1 i can).
> >>
> >> For now, this is the oops:
> >>
> >> [13092.479019] BUG: unable to handle kernel paging request at virtual
> >> address b9d0458f
> 
> Timer hash list contains a user address.

Dammit. It's a HT enabled box again. I don't have one.

Folkert, does the problem go away when you disable HT
(CONFIG_SCHED_SMT) ?

	tglx


