Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZCLRBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZCLRBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZCLRBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:01:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42222 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZCLRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:01:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
References: <200903110925.37614.phillips@phunq.net>
	<20090311230713.d4710050.akpm@linux-foundation.org>
	<200903120133.02645.phillips@phunq.net>
	<200903121947.58367.nickpiggin@yahoo.com.au>
Date: Fri, 13 Mar 2009 02:00:57 +0900
In-Reply-To: <200903121947.58367.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Thu, 12 Mar 2009 19:47:57 +1100")
Message-ID: <87eix2oeuu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

>> There are a couple of issues, one is u64 being (long) instead of
>> (long long) as you say, and the other is variable type sizes like
>> loff_t.  That specific one isn't actually a problem, we can just refuse
>> to support 32 bit libc file ops, but there may be others.  We had a
>> world of pain before (L) arrived, then with (L) it was easy.  Maybe
>> just edit them all to (long long) for now, and damn the line length.
>
> Yes please do this. A significant style change like this that lots of
> code already does I think is best first discussed as a standalone
> change to kernel rather than everyone developing their own convention.

BTW, personally I wonder whether there are any suggestion - how early
stage do we try to start review process? Someone suggests it should be
early, but how early?

I know tux3 still have to work for various things, however, people join
to develop those, and see the progress? Or people just want to see the
result of various work later? ...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
