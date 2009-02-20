Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZBTTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZBTTVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZBTTVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:21:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZBTTVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:21:42 -0500
Date: Fri, 20 Feb 2009 20:18:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] forget_original_parent: do not abuse
	child->ptrace_entry
Message-ID: <20090220191825.GB7564@redhat.com>
References: <20090211211218.GA16850@redhat.com> <20090220022823.9127AFC2F7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220022823.9127AFC2F7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Roland McGrath wrote:
>
> > - rename ptrace_dead to dead_childs.
>
> s/dead_childs/dead_children/

Yes, Andrew has already fixed this,

> > +/*
> > +* Any that need to be release_task'd are put on the @dead list.
> > + */
>
> Missing leading space on the second comment lien.

ah. will send the trivial cleanup.

> Modulo those cosmetic things, ACK on this.

Thanks.

Oleg.

