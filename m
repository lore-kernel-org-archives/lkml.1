Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbXLSNqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbXLSNqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXLSNqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:46:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXLSNqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:46:42 -0500
Date: Wed, 19 Dec 2007 14:45:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH] finish processor.h integration
Message-ID: <20071219134546.GA21282@elte.hu>
References: <1198008293639-git-send-email-gcosta@redhat.com> <20071219101736.GC3521@elte.hu> <5d6222a80712190415q7921b244ua073a8c64ab30597@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80712190415q7921b244ua073a8c64ab30597@mail.gmail.com>
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


* Glauber de Oliveira Costa <glommer@gmail.com> wrote:

> > i fixed it up by hand - the result is below - does it look OK to 
> > you? (Also, could you check latest x86.git whether i've picked up 
> > all your patches correctly - the reject might be indicative of some 
> > missing pieces.)
> 
> Your fix is okay. The other patches seems to be all there. The reason 
> for this is that it conflicts with Roland's (welcome) i387 patches.

ah, indeed - i forgot about that interaction. Your patches passed a
few hundred random builds and bootups meanwhile so i think they are
now 100% Perfect (tm) :-)

	Ingo
