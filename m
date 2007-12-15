Return-Path: <linux-kernel-owner+w=401wt.eu-S1764371AbXLONSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764371AbXLONSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXLONSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:18:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56678 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXLONSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:18:22 -0500
Date: Sat, 15 Dec 2007 14:17:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Message-ID: <20071215131723.GF9720@elte.hu>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com> <20071204193432.GI11764@bingen.suse.de> <20071205163017.GA4756@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205163017.GA4756@ucw.cz>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > Linux never uses that register. The only user is suspend 
> > save/restore, but that' bogus because it wasn't ever initialized by 
> > Linux in the first place. It could be probably all safely removed.
> 
> It probably is safe to remove... but we currently support '2.8.95 
> kernel loads/resumes 2.6.24 image'... which would break if 2.8 uses 
> cr8.
> 
> So please keep it if it is not a big problem.

hm, so __save_processor_state() is in essence an ABI? Could you please 
also send a patch that documents this prominently, in the structure 
itself?

	Ingo
