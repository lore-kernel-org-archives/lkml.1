Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862Ab0ASOaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0ASOaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733Ab0ASOav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:30:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:47472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0ASOau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:30:50 -0500
Date: Tue, 19 Jan 2010 12:30:37 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-perf-users@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Analysing an ARM perf.data file on a x86-64 workstation
Message-ID: <20100119143037.GH14636@ghostprotocols.net>
References: <20100108124244.GO4179@wear.picochip.com>
 <20100108125521.GB7485@ghostprotocols.net>
 <20100118163332.GA5789@wear.picochip.com>
 <20100118171035.GD14636@ghostprotocols.net>
 <20100118202451.GA4167@wear.picochip.com>
 <20100119000134.GE14636@ghostprotocols.net>
 <20100119000345.GF14636@ghostprotocols.net>
 <20100119091231.GC4167@wear.picochip.com>
 <20100119130958.GG14636@ghostprotocols.net>
 <20100119135145.GG4167@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119135145.GG4167@wear.picochip.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 19, 2010 at 01:51:45PM +0000, Jamie Iles escreveu:
> Hi Arnaldo,
> 
> On Tue, Jan 19, 2010 at 11:09:58AM -0200, Arnaldo Carvalho de Melo wrote:
> > CCing linux-perf-users, this may be interesting when investigating
> > similar problems for other arches.
> > 
> > Thanks James, got the vmlinux file and and already found and fixed two
> > bugs, patches sent CCed to you.
> > 
> > Ok, now how does it look like?
> Well, with both patches applied, I still don't see any kernel symbols in perf
> top (even the raw addresses) or resolved names in report if I specify a
> vmlinux or if one gets autodetected.

What if you try to do what I did, i.e. to try to decode the perf.data
file on your x86 workstation? Does specifying --vmlinux
/path/to/arm-vmlinux gets the symbols decoded?
 
- Arnaldo
