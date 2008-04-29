Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYD2KCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYD2KCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYD2KCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:02:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYD2KCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:02:12 -0400
Date: Tue, 29 Apr 2008 12:01:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Gerhard Mack <gmack@innerfire.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: don't bother printing compat vdso address
Message-ID: <20080429100152.GF23198@elte.hu>
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz> <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net> <48140ACF.4000500@goop.org> <alpine.DEB.1.10.0804281145090.17060@mtl.rackplans.net> <4816029D.3030508@goop.org> <alpine.DEB.1.10.0804281322200.17060@mtl.rackplans.net> <481611D3.9020302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481611D3.9020302@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The kernel prints the compat vdso address regardless of whether compat 
> vdso mode is enabled or not, which is confusing.  Given that this 
> isn't very interesting information anyway, just remove the printk.

thanks Jeremy, applied.

	Ingo
