Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZIXAez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZIXAez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZIXAex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:34:53 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:63168 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZIXAev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JIMcxA5zKrferxP++LvkwtGdqkr68654GGmrRS5npnsQ4kmJp+qyvqk5KS3/IGeiWA
         87/rZ3PZJ99f2tUJfxp0+3vKWekX3GOrOlzzUke6aMJ+XZ8fouv33jr98ZimUXaWsEwq
         9j1N/TBwR3/hFCkR5tDygUyVqUMDQIeHVeHZY=
MIME-Version: 1.0
In-Reply-To: <1253615424.20345.76.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
Date: Thu, 24 Sep 2009 09:34:54 +0900
Message-ID: <49b7c2350909231734h936f76fq5cdb056ff6144076@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: GeunSik Lim <leemgs1@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 7:30 PM, Raistlin <raistlin@linux.it> wrote:
>
> The project is hosted at the following URL:
>
>  http://www.evidence.eu.com/sched_edf.html
>
Hi Raistlin,

Thank you for challenge to support EDF on Linux 2.6 in private.

You have to modify  git address of schedtool-edf at
http://www.evidence.eu.com/sched_edf.html correctly.

before) git clone git://feanor.sssup.it/sched-tool-edf.git
after   ) git clone git://feanor.sssup.it/schedtool-edf.git

----- http://www.evidence.eu.com/sched_edf.html
---------------------------------
Usage with schedtool

 To easily test SCHED_EDF you can use our modified version of
schedtool as explained below.
For instance, to run a simple yes program with period 100000us and
budget 25000us, just type the following commands:

git clone git://feanor.sssup.it/sched-tool-edf.git * <-- Here, change
to schedtool-edf.git
cd schedtool-edf
make
./schedtool -E -d 100000 -b 25000 -a 0 -e yes > /dev/null &



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
