Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXJ2XWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXJ2XWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXJ2XWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:22:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXJ2XWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:22:07 -0400
Date: Tue, 30 Oct 2007 00:21:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071029232140.GA10518@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <47266431.1010500@goop.org> <20071029225528.GA31293@elte.hu> <47266A00.4040408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47266A00.4040408@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > that's totally broken then. You cannot create an SMP-safe monotonic 
> > clocksource via interpolation - native does not do it either. Good thing 
> > this problem got exposed, it needs to be fixed.
> >   
> 
> Sigh, I don't really want to have this fight again.

i dont remember us having discussed this before, ever. If there's any 
"fight" about monotonicity and SMP then it would be a pretty onesided 
affair, with you being beaten up seriously ;-)

> I don't really see what point there is in raising the tsc's rating 
> (why is 300 insufficient again?), but regardless of the value, the Xen 
> clocksource rating needs to be higher.

anyway, i agree that this patch cannot go in in its current form.

	Ingo
