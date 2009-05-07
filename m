Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZEGGuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZEGGuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZEGGty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:49:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZEGGtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:49:53 -0400
Date: Thu, 7 May 2009 08:45:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090507064559.GC15220@redhat.com>
References: <20090506053324.GA31988@redhat.com> <20090506200949.4FF6CFC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506200949.4FF6CFC39E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Roland McGrath wrote:
>
> I like the idea just fine.  Drop the "w" on every field name.
> If you want them to have a greppable uniqueness/prefix,

Yes!

> use "wo_".
> I'd go with a shorter name for the canonical pointer parameter,
> like "w" or "wo".

Done.

> It looks cleaner to me to keep the several args to do_wait() and have
> it use a single initializer with = { .foo = a, .bar = b } syntax there.

Yes, I considered this option too. But since (I hope) you do not have
a strong opinion on this, I'd prefer to keep the code as is. This way
do_wait() looks more symmetrical wrt to other helpers. And we don't
copy args twice.

Oleg.

