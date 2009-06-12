Return-Path: <linux-kernel-owner+w=401wt.eu-S1765331AbZFLRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765331AbZFLRlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764842AbZFLRlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:41:11 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:55409 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763159AbZFLRlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wCes5H36uk+s47UwhV88A9SXABm5UXTJuWtcTUgUzhl4ovQQ2E8Cohw8g6b2SV5w2q
         KtOzxL4IBryLPmD6mCckIByNcU0n/sdyXlbnGDd3rW7D6MPeHXD893iS1dk8uSuABGci
         8X6HW6fjF+Pf1z0aTHaGXmy5EqiDoI1bnctow=
MIME-Version: 1.0
In-Reply-To: <20090612173647.GC22015@elte.hu>
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org> 
	<20090612173031.GA11233@elte.hu> <8bd0f97a0906121032p12710878h14c5013fbec58b91@mail.gmail.com> 
	<20090612173647.GC22015@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 13:40:52 -0400
Message-ID: <8bd0f97a0906121040m5222cd5et77ecc1bd5edb6b89@mail.gmail.com>
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS 
	requirements
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 13:36, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Fri, Jun 12, 2009 at 13:30, Ingo Molnar wrote:
>> > * Mike Frysinger <vapier@gentoo.org> wrote:
>> >> Help out arch porters who want to support perf counters by listing some
>> >> basic requirements.
>> >>
>> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> >> ---
>> >> i imagine more details would be good, but this is a starting point and
>> >> better than nothing
>> >>
>> >>  init/Kconfig          |    2 ++
>> >>  tools/perf/design.txt |   15 +++++++++++++++
>> >>  2 files changed, 17 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/init/Kconfig b/init/Kconfig
>> >> index c649657..20f85b1 100644
>> >> --- a/init/Kconfig
>> >> +++ b/init/Kconfig
>> >> @@ -936,6 +936,8 @@ config AIO
>> >>
>> >>  config HAVE_PERF_COUNTERS
>> >>       bool
>> >> +     help
>> >> +       See end of tools/perf/design.txt
>> >>
>> >>  menu "Performance Counters"
>> >
>> > Applied, thanks Mike! I have made a small change: i changed it from
>> > help text into a regular comment. We usually use help texts for
>> > interactive Kconfig options - but this is not one.
>>
>> yes, but i like the help text because when i use the kconfig
>> search option, it shows up.  otherwise doing a search for
>> HAVE_PERF_COUNTERS shows nothing useful.
>
> When i did this modification i tried that in 'make menuconfig' and
> the help didnt show up. Is it only available in certain kconfig
> methods?

hrm, you're right.  not sure what i was thinking of.  sounds like an
enhancement request though for kconfig.
-mike
