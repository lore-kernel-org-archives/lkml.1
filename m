Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0CKNPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:15:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53607 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab0CKNPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:15:07 -0500
Date: Thu, 11 Mar 2010 14:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Dieter Ries <mail@dieterries.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OPTPROBES: Don't default to y in Kconfig
Message-ID: <20100311131501.GB11837@elte.hu>
References: <1268089658-19919-1-git-send-email-mail@dieterries.net>
 <4B967000.5070904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B967000.5070904@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Dieter Ries wrote:
> > CONFIG_OPTPROBES should not default to y while still being flagged
> > EXPERIMENTAL.
> 
> Hm, OK, indeed it still needs some more user tests.
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Well, since this is a prime time optimization i'd rather see the Kconfig value 
eliminated and the optimization to become unconditional. (if it doesnt work 
somewhere then it should be fixed)

	Ingo
