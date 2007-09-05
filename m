Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXIERKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXIERKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXIERKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:10:08 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:58954 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754467AbXIERKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:10:05 -0400
Date: Wed, 5 Sep 2007 19:11:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Patrick Mau <mau@oscar.ping.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hang in 2.6.23-rc5
Message-ID: <20070905191145.31003be2@hyperion.delvare>
In-Reply-To: <20070903063904.GA1935@oscar.prima.de>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
	<6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
	<5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
	<20070902232939.f2c8acbb.francois.cami@free.fr>
	<20070903063904.GA1935@oscar.prima.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 08:39:04 +0200, Patrick Mau wrote:
> On Mon, Sep 03, 2007 at 04:15:01AM +0530, Satyam Sharma wrote:
> > That's my impression as well. That's way too core/busy a codepath to have
> > a bug in. As I said earlier, almost anybody testing -rc5 is sure to hit
> > this within a few hours (probably less) -- sad, it greatly erodes from the
> > usefulness of -rc5 as a release candidate.
> 
> The above patch also fixed my problems using NFS mounted home directories.
> 
> I already applied it yesterday without giving any feedback, so I just
> thought I should comment.
> 
> In addition I totally agree with Satyam's comment above: either
> anybody is testing rc's these days, or people simply stopped reporting.

I've hit the problem, found this thread, found the proposed patch and
tried it. Presumably others did the same. It's not easy to report a
hang which leaves no message in the logs and happens at random,
infrequent times. It takes time to gather enough information to make a
useful report. And it takes time to make sure that the patch actually
fixed the problem, too.

(Satyam's estimation that everybody would hit the bug within an hour
doesn't match my experience, I had "only" 2 freezes in 60 hours or so.)

> My concern is that we have to live with a git tree that has this
> problem, because core developers are unavailable and nobody has the
> authority to commit this fix. (That was already posted before).

The fix appears to be in the tree already, so you needn't worry.

-- 
Jean Delvare
