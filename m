Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab0BPKUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab0BPKUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:20:30 -0500
Date: Tue, 16 Feb 2010 11:19:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
Message-ID: <20100216101903.GA1057@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B79B202.5090006@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, H. Peter Anvin wrote:
>
> On 02/15/2010 11:41 AM, Roland McGrath wrote:
> > It affects whatever uses is_compat_task(), but I can't see anything
> > where that matters except inside some particular syscall or for
> > syscall restart after signals.
>
> FWIW, the origin of this is checkin
> 4d9bc79cd28b779610d9590b3a96a28a0f64a25a (2.6.18-rc1), which somewhat
> unhelpfully states "Make sure is_compat_task works early".  It doesn't
> specify what the failure is if is_compat_task doesn't work early.

Perhaps Andi could explain us why this is needed,

> On
> the other hand, it sure as heck seems better to set it and not need it
> than the other way around.

Agreed, but otoh it is always good to understand the code. If we
really have a reason for TS_COMPAT, a small comment can help other
readers.

Oleg.

