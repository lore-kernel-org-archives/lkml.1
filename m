Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850Ab0A0J4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0A0J4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377Ab0A0J4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:56:14 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36472 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab0A0J4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HYLCCNUV1aF3Zc8lsfMJH15j1YcZJ2ZAAmdY4oBbIZqEjqyH6FX9lqMb8Wsv1n4V9H
         XfjiO3Fipo+4VkAj/XWDJNWQHuSTDF7YrQqHwVY0e3flii52w73pag0MJGn9aVnSMhjz
         gEioRZO1q/JtQuj1buYEzko6YGiHy7UNE/d00=
MIME-Version: 1.0
In-Reply-To: <20100127091903.6AD5.A69D9226@jp.fujitsu.com>
References: <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com>
	 <89khjo$egh4fr@orsmga002.jf.intel.com>
	 <20100127091903.6AD5.A69D9226@jp.fujitsu.com>
Date: Wed, 27 Jan 2010 11:56:10 +0200
X-Google-Sender-Auth: cf0e7a6ca67f71f1
Message-ID: <84144f021001270156x7613c8b1ha0084b0abf604775@mail.gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Roman Jarosz <kedgedev@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 2:50 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Tue, 26 Jan 2010 22:03:06 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Please consider to revert such commit at once. Lots people reported
>> > the same issue.
>> > I really hope to stop bug report storm.
>>
>> Your CC did not reference the problem that you were discussing, nor that
>> it is even easier to trigger an OOM without the shrinker. Memory
>> exhaustion due to the excess usage of surfaces from userspace is not a new
>> issuer. So what is the problem you have encountered and how does running
>> the OOM killer earlier fix the issue of triggering the OOM killer?
>
> Why do you bother easy googling?
>
> example.
>
> 1) http://bugzilla.kernel.org/show_bug.cgi?id=14933
>        Subject    : OOM killer unexpectedly called with kernel 2.6.32
>        Submitter  : "A. Boulan" <arnaud.boulan@libertysurf.fr>
>        Date       : 2009-12-24 23:42
>        References : http://marc.info/?l=linux-kernel&m=126169821317492&w=4
>
> 2) http://bugzilla.kernel.org/show_bug.cgi?id=15015
>        Subject: blank screen at random times in laptop when sitting idle
>        From:    Jithin Emmanuel
>        Date:    2010-01-09 16:48:23
>
>        see comment #2
>
> 3) http://bugzilla.kernel.org/show_bug.cgi?id=15058
>        From:   Michael Reinelt
>        Date:   2010-01-14 16:39:51
>
> 4) Subject: Re: OOM kernel behaviour
>   From: David John <davidjon@xenontk.org>
>   Mon, 07 Dec 2009 11:04:24 +0530
>
> 5) This thread

Yes, we're very late in 2.6.33 cycle. Chris/Jesse, please apply
Motohiro-san's patch or revert the commit.

                                Pekka
