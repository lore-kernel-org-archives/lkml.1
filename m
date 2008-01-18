Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbYARVi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbYARVi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYARViV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:38:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbYARViU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:38:20 -0500
Date: Fri, 18 Jan 2008 22:37:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 0/10] Tree fixes for PARAVIRT
Message-ID: <20080118213711.GA24979@elte.hu>
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080118203259.GA3079@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118203259.GA3079@elte.hu>
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

> > The first fix is not even specific for PARAVIRT, and it's actually 
> > preventing the whole tree from booting.
> 
> on CONFIG_EFI, indeed :)

but in exchange you broke all of 32-bit with CONFIG_PARAVIRT=y. Which 
means you did not even build-test it on 32-bit, let alone boot test 
it...

	Ingo
