Return-Path: <linux-kernel-owner+w=401wt.eu-S1762600AbXK2Meq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600AbXK2Meq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXK2Meh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:34:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbXK2Meg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:34:36 -0500
Date: Thu, 29 Nov 2007 13:34:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Albert Cahalan <acahalan@gmail.com>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Message-ID: <20071129123401.GA16609@elte.hu>
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org> <20071128014901.4b303954@inria.fr> <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com> <20071128104622.GB19694@elte.hu> <787b0d920711281014i76f182b7xaba100247e4ee79a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920711281014i76f182b7xaba100247e4ee79a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Albert Cahalan <acahalan@gmail.com> wrote:

> > I am faced with incidents on an almost daily basis that show how 
> > much we kernel folks suck at defining new APIs. The only luck is 
> > that the set of system calls is fairly complete already - but in the 
> > rare case where we touch an API it's a catastrophy most of the time. 
> > With such an API track record we'd probably never survive as a 
> > user-space project.
> 
> Most of user-space is worse.

most of user-space is a 'leaf' node product, not infrastructure. The 
core infrastructure bits of userspace like glibc have a lot saner API 
practice than the kernel. (with a 10 times larger API exposure! There 
are 3000+ glibc APIs, contrast that with the few-hundred kernel APIs.)

> What shocks me is that people keep designing ABIs with structs that 
> contain holes. (data leaks, waste, portability trouble, etc.) This 
> happens in kernel ABIs all the time. It ought to be blocked by some 
> sort of build tool. (with a whitelist for old stuff)

what shocks me more is the wide gap between talk and deed ;-) Really, 
you had strong (and mostly unjust) words towards the containers stuff, 
with little constructive criticism - while what started out this 
discussion was your (in hindsight) shortsighted choice of mucking with 
/proc/self years ago. We all make mistakes but you seem to even be proud 
of it. If your goal is to bring Linux forward please become more 
constructive and cut out the insults towards others. (and you'll 
magically see less insults go in your general direction as well ;-)

	Ingo
