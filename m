Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbXK3ALZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbXK3ALZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762451AbXK3ALL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:11:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbXK3ALJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:11:09 -0500
Date: Fri, 30 Nov 2007 01:10:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Albert Cahalan <acahalan@gmail.com>,
       Guillaume Chazarain <guichaz@yahoo.fr>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl,
       roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Message-ID: <20071130001029.GA17936@elte.hu>
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org> <20071128014901.4b303954@inria.fr> <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com> <20071128104622.GB19694@elte.hu> <m1ve7mehcm.fsf@ebiederm.dsl.xmission.com> <787b0d920711280947g418330faie5c96293102c3f05@mail.gmail.com> <m1hcj4buim.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcj4buim.fsf@ebiederm.dsl.xmission.com>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > You'll never run out of this sort of problem. Keeping Linux lean and 
> > simple would be far better.
> 
> Nah.  The control group stuff has all kinds of corner cases because it 
> is a new and untested API.  The namespace work after we get the code 
> cleanup up so it is maintainable and we can work with it is usually 
> just finding our globals through a pointer instead of from a static 
> variable.  Hardly a measurable cost on the best day.

yeah - anyone who claims that containers are 'fat' has likely not even 
looked at the code. Even maintainance-wise there's very visible positive 
effects: we do discover and properly map our "global resource" 
dependencies and abstract them. That increases cleanliness of our code 
and APIs all around.

	Ingo
