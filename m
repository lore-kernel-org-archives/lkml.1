Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZCXKNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZCXKNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbZCXKMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:12:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540AbZCXKMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:12:47 -0400
Date: Tue, 24 Mar 2009 11:12:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
Message-ID: <20090324101232.GA26228@elte.hu>
References: <1237884846.25315.37.camel@penberg-laptop> <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop> <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop> <20090324091742.GB6605@elte.hu> <1237886559.25315.60.camel@penberg-laptop> <20090324093103.GA19463@elte.hu> <20090324093424.GA26935@elte.hu> <20090324094605.GA20937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324094605.GA20937@elte.hu>
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


allyes is fine now. There's an allnoconfig failure:

init/built-in.o: In function `start_kernel':
(.init.text+0x669): undefined reference to `kmemtrace_init'

	Ingo
