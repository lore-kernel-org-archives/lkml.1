Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZHCX41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZHCX41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZHCX40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:56:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZHCX4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:56:25 -0400
Date: Tue, 4 Aug 2009 01:53:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] introduce tracehook_finish_jctl() helper
Message-ID: <20090803235306.GA6821@redhat.com>
References: <20090729020139.GA7381@redhat.com> <20090729155007.f4f5a793.akpm@linux-foundation.org> <20090801233207.E1FEB4C7FF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801233207.E1FEB4C7FF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Roland McGrath wrote:
>
> > Confused.  This patch has no effect.
>
> Indeed, the three patches changing do_signal_stop() have no immediate
> material effect.  They all just clean up the code and prepare the hooks
> that utrace (or something like it) needs to make tracing stops mesh well
> with job control stops.  I'd thought it might be simpler for review to just
> roll these three together and send you a single patch to replace
> signals-tracehook_notify_jctl-change.patch; but Oleg decided to keep it
> sliced smaller.

But let me repeat, I would be happy if these 2 new patches are folded
into signals-tracehook_notify_jctl-change.patch.

Oleg.

