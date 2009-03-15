Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbZCOE1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbZCOE1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZCOE1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:27:10 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:35252 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZCOE1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:27:09 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Daniel Phillips <phillips@phunq.net>
Cc: tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
References: <200903110925.37614.phillips@phunq.net>
	<200903120133.02645.phillips@phunq.net>
	<87ljraof5u.fsf@devron.myhome.or.jp>
	<200903142036.50335.phillips@phunq.net>
Date: Sun, 15 Mar 2009 13:26:53 +0900
In-Reply-To: <200903142036.50335.phillips@phunq.net> (Daniel Phillips's
	message of "Sat, 14 Mar 2009 20:36:50 -0700")
Message-ID: <873adfh0mq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:

>> BTW, those are almost because of userland issue. Kernel are more and
>> more using same type. But, glibc is not. And we (tux3) are sharing the
>> same code with kernel and userland. Some types are depending to
>> CONFIG_*, so if we have generic cast type like (L).
>> 
>> [The fatfs also has own type (llu), if it become generic, fatfs will
>> also be happy.]
>> 
>> Thanks.
>
> Maybe we should argue for some generic flavor of the (L)/(llu) idea
> then.  I suppose we should figure out exactly how much of our usage
> will remain after the kernel issue is resolved.  One small thing we
> could do is make it a typedef instead of a macro.

It is already typedef?

typedef long long L; // widen for printf on 64 bit systems

> And spelling it out completely as (long long) is not so bad, except it
> loses the desirable property of being able to grep for the messy
> thing, and adds a painful amount of useless line length, given how
> frequently the issue shows up.

Yes. Well, it is depending on the warn/info/trace strategy of the
modules. I guess so many modules are not requiring it, because there is
no trace. But, if those are implementing the trace code or something
like it, I guess (long long) will bother devlopers.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
