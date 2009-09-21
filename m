Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZIUTgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZIUTgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZIUTgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:36:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49251 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbZIUTgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:36:50 -0400
Date: Mon, 21 Sep 2009 21:36:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tony Vroon <tony@linx.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
Message-ID: <20090921193649.GD12048@elte.hu>
References: <1253560490.2934.42.camel@localhost> <4AB7D349.4000802@zytor.com> <1253561749.2934.47.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253561749.2934.47.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Vroon <tony@linx.net> wrote:

> On Mon, 2009-09-21 at 12:26 -0700, H. Peter Anvin wrote:
> > Could you please do a git bisect on this problem?
> 
> Would love to, but how do I convert g99bc470 to a correct git revision
> number please?
> 
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect start
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect bad
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect good g99bc470
> fatal: Needed a single revision
> Bad rev input: g99bc470

strip the leading g. (which stands for Git)

i.e. 99bc470.

	Ingo
