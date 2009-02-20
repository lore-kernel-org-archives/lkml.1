Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZBTC2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZBTC2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZBTC2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:28:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZBTC2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:28:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] forget_original_parent: do not abuse
	child->ptrace_entry
In-Reply-To: Oleg Nesterov's message of  Wednesday, 11 February 2009 22:12:18 +0100 <20090211211218.GA16850@redhat.com>
References: <20090211211218.GA16850@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090220022823.9127AFC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 18:28:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - rename ptrace_dead to dead_childs.

s/dead_childs/dead_children/

> Actually, I don't understand why do we notify /sbin/init when we
> reparent a zombie, probably it is better to reap it unconditionally.

It is traditional behavior.  It gives the init implementation the option to
report/log/analyze the details of abandoned zombies.  (Whether or not that
really seems useful, there is no good reason to restrict the possibility.)

> +/*
> +* Any that need to be release_task'd are put on the @dead list.
> + */

Missing leading space on the second comment lien.

Modulo those cosmetic things, ACK on this.


Thanks,
Roland
