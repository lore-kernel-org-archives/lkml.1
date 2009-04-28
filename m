Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZD1STF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZD1STF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZD1SSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:18:49 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:31744 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZD1SSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xZnBo7bko9rRRwKuyoDGAHBcBmcR45/3p/kEzYklLJh2ODzOXp8Ns9NJY8Y+FV3+7R
         4016wBb5fwMh8vH5ihNIAGW83/KsAZ/8Vx7nhHPmbWHX6fUYMi/+oj1OfJoEpqy19VBU
         MNP83+QqBfEbR6haXsnIfk+fXusjfJhiWjWKs=
MIME-Version: 1.0
In-Reply-To: <20090428083320.GB17038@localhost>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu>
	 <20090428083320.GB17038@localhost>
Date: Tue, 28 Apr 2009 11:11:52 -0700
Message-ID: <12c511ca0904281111r10f37a5coe5a2750f4dbfbcda@mail.gmail.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Tony Luck <tony.luck@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 1:33 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 1) FAST
>
> It takes merely 0.2s to scan 4GB pages:
>
>        ./page-types  0.02s user 0.20s system 99% cpu 0.216 total

OK on a tiny system ... but sounds painful on a big
server. 0.2s for 4G scales up to 3 minutes 25 seconds
on a 4TB system (4TB systems were being sold two
years ago ... so by now the high end will have moved
up to 8TB or perhaps 16TB).

Would the resulting output be anything but noise on
a big system (a *lot* of pages can change state in
3 minutes)?

-Tony
