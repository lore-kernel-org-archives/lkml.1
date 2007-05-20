Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbXETVX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbXETVX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbXETVXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:23:52 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:53256 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbXETVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:23:51 -0400
Date: Sun, 20 May 2007 23:23:50 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andi Kleen <ak@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       righiandr@users.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070520212350.GM22452@vanheusden.com>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <20070520212036.GL22452@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070520212036.GL22452@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Mon May 21 15:25:37 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	switch(sig) {
> > > +	case SIGQUIT: 
> > > +	case SIGILL: 
> > > +	case SIGTRAP:
> > > +	case SIGABRT: 
> > > +	case SIGBUS: 
> > > +	case SIGFPE:
> > > +	case SIGSEGV: 
> > > +	case SIGXCPU: 
> > > +	case SIGXFSZ:
> > > +	case SIGSYS: 
> > > +	case SIGSTKFLT:
> > Unconditional? That's definitely a very bad idea. If anything only unhandled
> > signals should be printed this way because some programs use them internally. 
> Use these signals internally? Afaik these are fatal, stopping the
> process. So using them internally would be a little tricky.
> > But I think your list is far too long anyways.
> 
> So, which ones would you like to have removed then?

(and why, of course, to enlighten me: some are educated guesses)


Folkert van Heusden

-- 
MultiTail ist eine flexible Applikation um Logfiles und Kommando
Eingaben zu überprüfen. Inkl. Filter, Farben, Zusammenführen,
Ansichten etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
