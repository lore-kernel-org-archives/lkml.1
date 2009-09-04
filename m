Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbZIDWYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbZIDWYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbZIDWYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:24:43 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33400 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933979AbZIDWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:24:42 -0400
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak 
	reports
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890909041458u505ce89tf38743dd6305bf7b@mail.gmail.com>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
	 <1251962791.3336.3.camel@johannes.local>
	 <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
	 <1252001837.9336.2.camel@johannes.local> <20090903204319.GC3701@mosca>
	 <1252040671.9336.10.camel@johannes.local>
	 <1252052757.26413.9.camel@pc1117.cambridge.arm.com>
	 <43e72e890909041421m243bbea6i95c26ab21dc8732d@mail.gmail.com>
	 <43e72e890909041458u505ce89tf38743dd6305bf7b@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 04 Sep 2009 23:24:27 +0100
Message-Id: <1252103067.21380.1.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2009 22:24:28.0223 (UTC) FILETIME=[7747BCF0:01CA2DAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 14:58 -0700, Luis R. Rodriguez wrote:
> On Fri, Sep 4, 2009 at 2:21 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> 
> > BTW I should not I got this kmemleak report after using the clear
> > command by painting objects black. I'll test it now with your
> > suggested changes.
> 
> So I pulled your git://linux-arm.org/linux-2.6 master into my tree and
> didn't even need a 'clear' command now, the output of
> /sys/kernel/debug/kmemleak is empty :), so I suspect you have quite a
> few changes which should help avoid getting false positives.
> 
> Will these changes make it for 2.6.32?

The kmemleak branch is planned for the upcoming merging window. I don't
think you need to merge the master branch as it has a lot of
arm-specific code.

-- 
Catalin

