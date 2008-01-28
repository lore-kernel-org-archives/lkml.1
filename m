Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYA1PsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYA1PsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYA1Prz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:47:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40497 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYA1Pry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:47:54 -0500
Date: Mon, 28 Jan 2008 16:47:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 00 of 11] x86: separate pmd lifetime from pgd
Message-ID: <20080128154724.GA22425@elte.hu>
References: <patchbomb.1201296189@localhost> <20080128151753.GA14451@elte.hu> <20080128154140.GA17017@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128154140.GA17017@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> and after a session of bisection, the winner patch is:
> 
>   Subject: x86: unify PAE/non-PAE pgd_ctor
> 
> which is a tad unexpected, given the relatively harmless nature of the 
> patch. (but then again, nothing is really harmless in PAE land.)

ok, i merged up your series with this patch removed. (it was possible 
with a few manual fixups) That way the problem .config boots fine.

	Ingo
