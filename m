Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXKBPUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXKBPUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXKBPTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:19:54 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:15332 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbXKBPTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NFdXn/7F90GtKlR2omIjAA+49bhjewlWAVGXDLzhSQrEaEl1DiF8rQwyCh/p3sLoW1gdUDJGjop7Z1lbkR3Z6zTKUkMI5lo9uOz4ROtI6XogXRFKkSvm+yrakxLupcP6OVk5lsiGNCs2bMjr7eu0zxPWvwjHC0kuPTNB63M1aT8=
Message-ID: <b1c6420f0711020819y7140c338o718e60c933c1aa3a@mail.gmail.com>
Date: Sat, 3 Nov 2007 00:19:52 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <31286.1193785564@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	 <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
	 <15631.1193753689@redhat.com>
	 <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com>
	 <27157.1193763218@redhat.com>
	 <b1c6420f0710301459i147f0f00n1f7009139d3ac31a@mail.gmail.com>
	 <31286.1193785564@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late.

On 10/31/07, David Howells <dhowells@redhat.com> wrote:
> > But is there any utility that depends on that uname says mn10300?
>
> autoconf:-)

I forgot again the one as an host environment. :-)
AFAIK, mn10300 series are for embedded systems and I've never heard as
development hosts.
I had noticed the new machine name needs to be added / changed, though.

> Can you guarantee there won't be any non-AM33 variants of mn10300 that need
> supporting?  An AM34, perhaps?

I think `am33' is a reasonable name if  it is the first variant of
mn10300 series
that is supported by Linux, like `am33' is for glibc and `i386' is
(was) for Linux and others.
People don't misunderstand that an AM30, AM31 or AM32 is supported by Linux.
AM3n seems to be upper compatible with AM3(n-1), so far.
MEI (and only they) know if AM34, and any newer core in that series
are compatible with AM33.

> The discrepancy has been around for years, and I suspect it's not going to
> change now.  If MEI ask, I will change it.

I see.
I know there is no technical problem if the arch name continues to be mn10300.
It is an issue of some branding strategy, or a designing policy.
I understand you (RH) are not in a position to decide to change, nor
to refuse to change.

I just noticed and became worried about the mismatch.
If MEI ask you to change the toolchain name from am33 to mn10300, I
have no objection to that.
I'd be glad to hear any comments from MEI.


-- 
Suzuki Takashi
Japan
