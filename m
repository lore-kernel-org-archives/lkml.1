Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZEKMnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZEKMnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZEKMn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:43:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZEKMn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:43:27 -0400
Date: Mon, 11 May 2009 14:43:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090511124314.GJ13954@elte.hu>
References: <20090506053324.GA31988@redhat.com> <20090506072756.GA17457@elte.hu> <20090507064120.GB15220@redhat.com> <20090507075417.GA9836@elte.hu> <20090509161506.GA8150@redhat.com> <20090511105354.GB30651@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511105354.GB30651@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@canonical.com> wrote:

> On Sat, May 09, 2009 at 06:15:06PM +0200, Oleg Nesterov wrote:
> > (add Andy)
> > 
> > On 05/07, Ingo Molnar wrote:
> > >
> > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > > On 05/06, Ingo Molnar wrote:
> > > > >
> > > > > One small nit with the definition above: when using vertical spacing
> > > > > (which really looks nice) we tend to put the asterix to the type
> > > > > itself, not to the variable. I.e.:
> > > > >
> > > > > 	enum pid_type		wtype;
> > > > > 	struct pid *		wpid;
> > > > > 	int			wflags;
> 
> My expectation would normally be that this would be written more as:
> 
>  	enum pid_type		wtype;
>  	struct pid		*wpid;
>  	int			wflags;

Correct - i was confused there.

	Ingo
