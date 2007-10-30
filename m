Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXJ3V7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXJ3V7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXJ3V7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:59:34 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:50793 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXJ3V7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JSOLHjkd4CKXi31pz05jmSRk6kUfIXKfrywgPnUaVMVR8UL/T7TLmQ1jCZVWSQkILq5wwNyUDE3G4h+uudVOYnV2MejzhnVWyiETQCS0lQtGoFaauhUW/ngeb/NBgT4EZvtUDb2qRXAE2UNpVv4ppt/QzKo7xJvRAxXAttIoCAw=
Message-ID: <b1c6420f0710301459i147f0f00n1f7009139d3ac31a@mail.gmail.com>
Date: Wed, 31 Oct 2007 06:59:32 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <27157.1193763218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	 <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
	 <15631.1193753689@redhat.com>
	 <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com>
	 <27157.1193763218@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, David Howells <dhowells@redhat.com> wrote:
> > But the arch name change does not affect running kernels on consumer devices.
>
> uname says mn10300.

Oh, I forgot.
But is there any utility that depends on that uname says mn10300?

> > Drastic changes in the directory and file structures will have
> > a much greater impact than that.
>
> Like renaming the arch/mn10300 and include/asm-mn10300 directories and having
> to tell people already using ARCH=mn10300 that they've got to change.

I know existing developers should learn the arch name change.
But how many developers?

> > New contributors cannot recognize the am33 glibc is for the mn10300 Linux.
>
> They can if they're told so, plus if they've got the CPU docs to hand, it
> should be more obvious.  The AM33 is a variant of the MN10300 arch as far as I
> can tell.

That's the point. They must always be told or consult the documentations.
Don't you think an arch name should be natural?
People need not to be told on other, at least major, archs.

It's
- growing new developers will have difficulties in understanding arch
name difference,
versus
- fewer people have to learn the arch name change.
I vote the latter now.


-- 
Suzuki Takashi
Japan
