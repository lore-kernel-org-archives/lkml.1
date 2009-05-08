Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbZEHLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbZEHLQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762923AbZEHLPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:15:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762821AbZEHLPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:15:03 -0400
Date: Fri, 8 May 2009 13:14:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/16] xen: disable PAT
Message-ID: <20090508111432.GF11596@elte.hu>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org> <1241730653-4688-7-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241730653-4688-7-git-send-email-jeremy@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Impact: disable PAT under Xen
> 
> Xen imposes a particular PAT layout on all paravirtual guests which
> does not match the layout Linux would like to use.
> 
> Force PAT to be disabled until this is resolved.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

hm, what will the resolution be? Every step in the direction of 
making Xen guests more special is a step in the wrong direction. 
Coupling between Xen and Linux should be reduced, not increased.

	Ingo
