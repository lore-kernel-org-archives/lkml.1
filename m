Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZANC2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZANC2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZANC2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:28:39 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:63016 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZANC2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=b3frUAAo6f2adSpOw/AmrzfpKgMO8HF8XiJCMp2xQ6dlvKPdxLjOTVB+bhzL9vfK8u
         0eRmEemTBOg49XudTBXlDD4PJ0d+gxuADBJHc+g6ByLUxSo980CPwAmcR5+Jdzbt4wJ/
         NLoJ1JbcNUKY2+cAgpI/lAQWrdiG6crLaT3wg=
Message-ID: <cfd18e0f0901131828p3a737e6cx317ccda67ba9f733@mail.gmail.com>
Date: Wed, 14 Jan 2009 15:28:35 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Cc: "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901131808070.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain>
	 <cfd18e0f0901131653y76a827b5i906fadce63ada56b@mail.gmail.com>
	 <alpine.LFD.2.00.0901131655040.6528@localhost.localdomain>
	 <cfd18e0f0901131739v5119271flc28b5531604e682@mail.gmail.com>
	 <alpine.LFD.2.00.0901131808070.6528@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 3:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 14 Jan 2009, Michael Kerrisk wrote:
>>
>> It isn't an extension.  It's an accident.
>
> Bah. It doesn't matter. It's an ABI. Your arguments make no sense - simply
> because there are other differences that means that if you develop under
> one OS, you can't expect it to run on another.

(I don't think implied such an expectation.  On the other hand, we can
do things to make more or less difficult for writers of portable
applications.)

> Arguing that "accident" is somehow different than "extension" is a totally
> inane and _idiotic_ argument. Because it's just arguing about the words,
> not about the end result.
>
> If you're doing a dissertation in English literature, arguing about the
> words you use is valid. But if you're talking about operating systems,
> it's just pointless masturbation.

I agree that for practical purposes with respect to waitid(),
"extension" versus "accident" is only about words: we've had the
interface in its current form for so long that changing it shouldn't
be done without consideration.

But (and this was why I constrasted "extension" with "accident"), I
already made it clear that IMO there was another point that was more
important than this specific case:

: And the fact that such accidents happen more often than necessary is
: the real problem, rather than the fact that this API in particular is
: inconsistent with expectations.

but you responded to the point I found less important.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
