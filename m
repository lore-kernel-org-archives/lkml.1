Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZFXT0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZFXT0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZFXTZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:25:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbZFXTZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:25:53 -0400
Date: Wed, 24 Jun 2009 18:11:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
Message-ID: <20090624161111.GA27890@redhat.com>
References: <20090622170437.GA4906@redhat.com> <20090624091316.73D0F4059B@magilla.sf.frob.com> <20090624152143.GB23848@redhat.com> <20090624185701.AA74C4059B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624185701.AA74C4059B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Roland McGrath wrote:
>
> > > (and ->parent is perhaps
> > > not right in all cases there).
> >
> > I think this is right... Except I'd like to avoid using ->parent.
>
> Agreed.  The not-right case I had in mind was do_notify_parent_cldstop
> where maybe it could be ->real_parent of the untraced group_leader.

Hmm. Could you explain?

I feel I missed something, but can't understand.

Oleg.

