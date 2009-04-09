Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbZDIEkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbZDIEkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbZDIEjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:39:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760207AbZDIEjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:39:04 -0400
Date: Thu, 9 Apr 2009 06:38:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
Subject: Re: Multiple Tracers
Message-ID: <20090409043841.GA5352@elte.hu>
References: <1239197703.3359.25.camel@localhost.localdomain> <20090408135312.GR18581@elte.hu> <1239199899.3359.39.camel@localhost.localdomain> <20090408142413.GF12931@elte.hu> <49DD5964.8000803@cn.fujitsu.com> <20090409025507.GB24946@ghostprotocols.net> <49DD6791.2010507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DD6791.2010507@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> >>> Tom Zanussi (Cc:-ed) recently converted the blktrace tracepoints to 
> >> I guess you mean Arnaldo <acme@redhat.com> ;)
> > 
> > Nope, Tom:
> > 
> > Message-Id: <1235725261.8512.89.camel@charm-linux>
> >  
> 
> Ah, sorry for the mistake, I didn't notice that patch, and I 
> thought Ingo meant the ftrace-plugin patch.

yeah - i meant the Zed-trace patches Tom posted some time ago.

I think it would be nice to use the blktrace bits of it too, to 
extend built-in user-defined per tracepoint filtering expressions to 
blktrace and to make blktrace events more generally available. It 
does not impact existing blktrace functionality, it extends on it.

	Ingo
