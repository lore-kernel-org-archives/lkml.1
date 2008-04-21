Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbYDUMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbYDUMhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932147AbYDUMge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:36:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbYDUMgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:36:33 -0400
Date: Mon, 21 Apr 2008 14:36:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 signals: lift set_fs
Message-ID: <20080421123615.GD9554@elte.hu>
References: <20080419212654.9971827037C@magilla.localdomain> <20080419212756.ABAF227037C@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419212756.ABAF227037C@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2887]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> This lifts the set_fs(USER_DS) call for signal handler setup out of 
> the three places copying the same code into the one place that calls 
> them all.  There is no change in what it does.

thanks, applied.

	Ingo
