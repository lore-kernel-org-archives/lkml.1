Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZFLRdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZFLRdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZFLRc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:32:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:16212 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZFLRc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V8UzTtP1BTd4eH6BHviCVEZp53LdgQdsnBJkxtdu3HO/oCv0hXE9WQyjYOSD1rSBoF
         aTw0UFwHGI+3jrk3FYkxvx6dDdkMJyzBSZwe+FWHFv1f5EvuMLnPtrpUgBkuRR5lqpKO
         8HSlXIHLmsgwo7Ih2KPOFNll8vIsCtnVcvMQo=
MIME-Version: 1.0
In-Reply-To: <20090612173031.GA11233@elte.hu>
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org> 
	<20090612173031.GA11233@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 13:32:40 -0400
Message-ID: <8bd0f97a0906121032p12710878h14c5013fbec58b91@mail.gmail.com>
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

On Fri, Jun 12, 2009 at 13:30, Ingo Molnar wrote:
> * Mike Frysinger <vapier@gentoo.org> wrote:
>> Help out arch porters who want to support perf counters by listing some
>> basic requirements.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> i imagine more details would be good, but this is a starting point and
>> better than nothing
>>
>>  init/Kconfig          |    2 ++
>>  tools/perf/design.txt |   15 +++++++++++++++
>>  2 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index c649657..20f85b1 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -936,6 +936,8 @@ config AIO
>>
>>  config HAVE_PERF_COUNTERS
>>       bool
>> +     help
>> +       See end of tools/perf/design.txt
>>
>>  menu "Performance Counters"
>
> Applied, thanks Mike! I have made a small change: i changed it from
> help text into a regular comment. We usually use help texts for
> interactive Kconfig options - but this is not one.

yes, but i like the help text because when i use the kconfig search
option, it shows up.  otherwise doing a search for HAVE_PERF_COUNTERS
shows nothing useful.
-mike
