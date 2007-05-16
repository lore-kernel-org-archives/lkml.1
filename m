Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbXEPI6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbXEPI6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXEPI6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:58:09 -0400
Received: from www.osadl.org ([213.239.205.134]:45999 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753641AbXEPI6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:58:08 -0400
Subject: Re: [2.6.21.1] OOPS in timer stats code
From: Thomas Gleixner <tglx@linutronix.de>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070516080011.GA3304@vanheusden.com>
References: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl>
	 <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com>
	 <4649FDEA.2050703@redhat.com> <1179267292.12838.42.camel@chaos>
	 <20070516080011.GA3304@vanheusden.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 11:02:19 +0200
Message-Id: <1179306139.12838.69.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 10:00 +0200, Folkert van Heusden wrote:
> > > >> Hi,
> > > >> After an uptime of, say, 4 hours I got an oops on my P4 with HT and
> > > >> 2GB ram.
> > > >> It has dynamic ticks enabled as well has timer stats. I cannot reboot the
> > > >> machine to give more details right now (19:00 gmt+1 i can).
> > > >> For now, this is the oops:
> > > >> [13092.479019] BUG: unable to handle kernel paging request at virtual
> > > >> address b9d0458f
> > > Timer hash list contains a user address.
> > 
> > Dammit. It's a HT enabled box again. I don't have one.
> > Folkert, does the problem go away when you disable HT
> > (CONFIG_SCHED_SMT) ?
> 
> Don't know but the last patch I got works fine it seems (10 hours up).

/me lost context. Which patch ?

	tglx


