Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYI3H65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYI3H65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYI3H6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:58:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYI3H6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:58:49 -0400
Date: Tue, 30 Sep 2008 09:58:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN
Message-ID: <20080930075838.GC20241@elte.hu>
References: <20080929182423.268c4283@redhat.com> <48E16A2E.10603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E16A2E.10603@goop.org>
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

> Chuck Ebbert wrote:
> > From: Chuck Ebbert <cebbert@redhat.com>
> >
> > xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN
> >
> > Xen options need to depend on XEN.
> > Also, add newline at end of file.
> >
> > Without this patch you need to disable CONFIG_PM in order to
> > disable CPU hotplugging.
> >
> > Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> >   
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/xen, thanks! (hand-applied it as this portion already 
changed relative to mainline)

	Ingo
