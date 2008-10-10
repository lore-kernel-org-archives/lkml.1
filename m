Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbYJJPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbYJJPbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbYJJPbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:31:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbYJJPbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:31:03 -0400
Date: Fri, 10 Oct 2008 17:28:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       arnd@arndb.de, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect
	checkpoint/restart to work
Message-ID: <20081010152831.GA28977@elte.hu>
References: <20081009190405.13A253CB@kernel> <1223626834.8787.8.camel@localhost.localdomain> <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu> <48EF7211.2000303@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EF7211.2000303@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oren Laadan <orenl@cs.columbia.edu> wrote:

> 
> 
> Ingo Molnar wrote:
> > * Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
> > 
> >>> By the way, why don't you introduce the reverse operation ?
> >> I think implementing the reverse operation will be a nightmare, IMHO 
> >> it is safe to say we deny checkpointing for the process life-cycle 
> >> either if the created resource was destroyed before we initiate the 
> >> checkpoint.
> > 
> > it's also a not too interesting case. The end goal is to just be able to 
> > checkpoint everything that matters - in the long run there simply wont 
> > be many places that are marked 'cannot checkpoint'.
> > 
> > So the ability to deny a checkpoint is a transitional feature - a 
> > flexible CR todo list in essence - but also needed for 
> > applications/users that want to rely on CR being a dependable facility.
> > 
> > It would be bad for most of the practical usecases of checkpointing to 
> > allow the checkpointing of an app, just to see it break on restore due 
> > to lost context.
> 
> Actually it need not wait for restore to fail - it can fail during the 
> checkpoint, as soon as the unsupported feature is encountered.

correct, that is the idea.

	Ingo
