Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbXEPIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbXEPIA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXEPIAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:00:16 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:53487 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbXEPIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:00:14 -0400
Date: Wed, 16 May 2007 10:00:12 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.21.1] OOPS in timer stats code
Message-ID: <20070516080011.GA3304@vanheusden.com>
References: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl> <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com> <4649FDEA.2050703@redhat.com> <1179267292.12838.42.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179267292.12838.42.camel@chaos>
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
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a key-signing at www.biglumber.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> Hi,
> > >> After an uptime of, say, 4 hours I got an oops on my P4 with HT and
> > >> 2GB ram.
> > >> It has dynamic ticks enabled as well has timer stats. I cannot reboot the
> > >> machine to give more details right now (19:00 gmt+1 i can).
> > >> For now, this is the oops:
> > >> [13092.479019] BUG: unable to handle kernel paging request at virtual
> > >> address b9d0458f
> > Timer hash list contains a user address.
> 
> Dammit. It's a HT enabled box again. I don't have one.
> Folkert, does the problem go away when you disable HT
> (CONFIG_SCHED_SMT) ?

Don't know but the last patch I got works fine it seems (10 hours up).


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
