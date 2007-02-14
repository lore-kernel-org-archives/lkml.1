Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXBNKpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXBNKpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbXBNKpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:45:39 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56861 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXBNKpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:45:38 -0500
Date: Wed, 14 Feb 2007 13:41:51 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070214104151.GA32612@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu> <p73bqjxhcnl.fsf@bingen.suse.de> <20070213222443.GH22104@elte.hu> <20070213223017.GJ29492@one.firstfloor.org> <20070213224131.GK22104@elte.hu> <20070214091348.GB4665@2ka.mipt.ru> <20070214094629.GA6801@elte.hu> <20070214100955.GA23702@2ka.mipt.ru> <1171449055.12771.254.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1171449055.12771.254.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Wed, 14 Feb 2007 13:42:02 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:30:55AM +0100, Arjan van de Ven (arjan@infradead.org) wrote:
> > (at least on Debian
> > and Mandrake there is no locked memory limit by default).
> 
> that sounds like 2 very large bugtraq-worthy bugs in these distros.. so
> bad a bug that I almost find it hard to believe...

Well:

$ ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
max nice                        (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) unlimited
max locked memory       (kbytes, -l) unlimited
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) unlimited
max rt priority                 (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) unlimited
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
$ cat /etc/debian_version
4.0

$ ulimit -a
core file size        (blocks, -c) 0
data seg size         (kbytes, -d) unlimited
file size             (blocks, -f) unlimited
max locked memory     (kbytes, -l) unlimited
max memory size       (kbytes, -m) unlimited
open files                    (-n) 1024
pipe size          (512 bytes, -p) 8
stack size            (kbytes, -s) 8192
cpu time             (seconds, -t) unlimited
max user processes            (-u) 7168
virtual memory        (kbytes, -v) unlimited
$ cat /etc/mandrake-release
Mandrake Linux release 10.0 (Community) for i586

Anyway, even if there is a limit like in fc5 - 32kb,
so I doubt any unpriveledged userspace application 
will ever run there.

-- 
	Evgeniy Polyakov
