Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZATHLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZATHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZATHLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:11:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZATHLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:11:15 -0500
Date: Tue, 20 Jan 2009 08:08:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090120070854.GA28725@redhat.com>
References: <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com> <1232415319.3136.18.camel@zeus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232415319.3136.18.camel@zeus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Ian Kent wrote:
>
> I see you've already backed out part of your original change, which may
> have been a little premature,

I think this is fine. When/if we remove task_pgrp_nr() from fs/, we
can do the trivial patch which just removes this helper from sched.h.

And thanks for discussion. Somehow I forgot that the untested changes
is a pain for maintainers, and it was the bad idea to make the next
patch which depend on these changes.

Oleg.

