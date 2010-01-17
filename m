Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836Ab0AQOSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab0AQOSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0AQOSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:18:42 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59530 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0AQOSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZJ7CyrBGLzfawq0By61ixA7eFzQbYmy6UmwALVZvxhZLNm0PQrsaLi4ZBqOqMHOg0s
         7ZKIsUyIXaIZbJ4Z58VpvYPUs7CaItB89rLt+F9ouK2PDnepu4bDw5KOotDzfqo1vUYy
         z3GRfFIZeafYaoPBgucorG0yJblVedf9R++Rg=
MIME-Version: 1.0
In-Reply-To: <20100117123218.GA3182@redhat.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	 <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl>
	 <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain>
	 <20100117123218.GA3182@redhat.com>
Date: Sun, 17 Jan 2010 16:18:39 +0200
X-Google-Sender-Auth: dacf3a2b0289bcf8
Message-ID: <84144f021001170618g708a7c14ob1b222ab1cbdaa20@mail.gmail.com>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.ker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 2:32 PM, Michael S. Tsirkin
<m.s.tsirkin@gmail.com> wrote:
> On Sat, Jan 16, 2010 at 02:04:07PM -0800, Linus Torvalds wrote:
>>
>>
>> On Sat, 16 Jan 2010, Rafael J. Wysocki wrote:
>> >
>> > > Immediately upon startup, screen is flickering (becomes
>> > > lighter and darker again). The problem occurs with kernels
>> > > 2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.
>> >
>> > We've already had several reports like this already.
>> >
>> > Care to review the bugs linked to http://bugzilla.kernel.org/show_bug.cgi?id=14885
>> > and check if none of them matches the problem you describe?
>>
>> I suspect that should be fixed by commit 33814341f22 ("drm/i915: disable
>> LVDS downclock by default") that got merged today.
>>
>> So try current -git.
>>
>>               Linus
>
>
> Tested with 6ccf80eb15ccaca4d3f1ab5162b9ded5eecd9971, still get
> the flickering effect. so 33814341f22 does not seem to help.

Yeah, me too which is why I am doing a git bisect here. What's strange
about it is that the first bisection point seems to suggest that the
regression happened _before_ the DRM merge to 2.6.33-rc1. I guess it's
possible that the bug is already in 2.6.32 but I've yet to see the
flickering effect. Oh well, back to bisect...

                        Pekka
