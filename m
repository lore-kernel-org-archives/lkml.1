Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZBJMTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZBJMTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZBJMSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:18:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZBJMSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:18:54 -0500
Date: Tue, 10 Feb 2009 13:18:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Message-ID: <20090210121823.GC19297@elte.hu>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Tue, Feb 10, 2009 at 6:41 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> >
> > I periodically test kernel on stress workload.
> > Unfortunately, recent kerenel don't survive >24H.
> >
> > It paniced with following stack.
> > Do you have any suggestions?
> >
> > thanks!
> 
> That stack trace looks somewhat similar to the one in
> http://lkml.org/lkml/2009/2/6/136
> 
> If this is reproducible, maybe a patch like the one attached can help
> pinpoint it?

hm, it might also be related to the SLAB corruption i reported a month
ago, in this area of code:

 http://bugzilla.kernel.org/show_bug.cgi?id=12503
 http://marc.info/?l=linux-kernel&m=123204353425825&w=4

it appeared in the merge window.

	Ingo
