Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYKCItL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYKCItL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYKCItA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:49:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYKCIs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:48:59 -0500
Date: Mon, 3 Nov 2008 09:48:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: Kill bogus MTRR warning when running under vmware
Message-ID: <20081103084842.GD11730@elte.hu>
References: <20081031170355.5368be60@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031170355.5368be60@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0382]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> x86: Kill bogus MTRR warning when running under vmware
> 
> The warning is suppressed when running under KVM, but VMware
> guests also have empty MTRRs.
> 
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=468845

we are working on proper "are we within vmware" detection support. 
Patches already exist and it is useful to know it for other reasons as 
wel.

	Ingo
