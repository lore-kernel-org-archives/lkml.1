Return-Path: <linux-kernel-owner+w=401wt.eu-S1161513AbXBOWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513AbXBOWTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161514AbXBOWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:19:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36816 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161513AbXBOWTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:19:34 -0500
Date: Thu, 15 Feb 2007 14:18:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
Message-Id: <20070215141841.6eed5fbb.akpm@linux-foundation.org>
In-Reply-To: <y0mvei330ee.fsf@ton.toronto.redhat.com>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
	<20070214231201.20918c6b.akpm@linux-foundation.org>
	<y0mvei330ee.fsf@ton.toronto.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Feb 2007 10:28:57 -0500
fche@redhat.com (Frank Ch. Eigler) wrote:

> 
> akpm wrote:
> 
> > [...]  And what can I do with these markers?  And once I've done it,
> > are there any userspace applications I can use to get the data out
> > in human-usable form?  [...]
> 
> The LTTng user-space programs use it today.  Systemtap used to support
> the earlier marker prototype and will be rapidly ported over to this
> new API upon acceptance.
> 

That's good.

It would be beneficial if some people from those projects could spare the
cycles to carefully review and runtime test this code.

Also, I'm not 100% clear on where we ended up with the huge
static-vs-dynamic flamewar.  Did everyone end up happy?  Is this patchset a
reasonable compromise?  Or do we need a rematch?
