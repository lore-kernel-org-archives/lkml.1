Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbXEPMDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbXEPMDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbXEPMDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:03:00 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:32978 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbXEPMC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:02:59 -0400
Date: Wed, 16 May 2007 14:02:58 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.21.1] OOPS in timer stats code
Message-ID: <20070516120258.GC3304@vanheusden.com>
References: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl> <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com> <4649FDEA.2050703@redhat.com> <1179267292.12838.42.camel@chaos> <20070516080011.GA3304@vanheusden.com> <1179306139.12838.69.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179306139.12838.69.camel@chaos>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed May 16 23:38:34 CEST 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to me with PGP!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > >> After an uptime of, say, 4 hours I got an oops on my P4 with HT and
> > > > >> 2GB ram.
> > > > >> It has dynamic ticks enabled as well has timer stats. I cannot reboot the
> > > > >> machine to give more details right now (19:00 gmt+1 i can).
> > > > >> For now, this is the oops:
> > > > >> [13092.479019] BUG: unable to handle kernel paging request at virtual
> > > > >> address b9d0458f
> > > > Timer hash list contains a user address.
> > > Dammit. It's a HT enabled box again. I don't have one.
> > > Folkert, does the problem go away when you disable HT
> > > (CONFIG_SCHED_SMT) ?
> > Don't know but the last patch I got works fine it seems (10 hours up).
> /me lost context. Which patch ?

The one by Jan Kara with Message-ID: <20070515191827.GB3677@duck.suse.cz>


Folkert van Heusden

-- 
www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
