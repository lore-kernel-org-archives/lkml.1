Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYAZN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYAZN4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYAZN4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:56:05 -0500
Received: from [212.12.190.207] ([212.12.190.207]:59234 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753713AbYAZN4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:56:03 -0500
From: Al Boldi <a1426z@gawab.com>
To: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
Subject: Kernel Event Notifications (was: [RFC] Parallelize IO for e2fsck)
Date: Sat, 26 Jan 2008 16:55:31 +0300
User-Agent: KMail/1.5
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <20080124234037.GJ15858@mit.edu> <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
In-Reply-To: <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801261655.31313.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > > And from a performance point of view letting applications voluntarily
> > > free some memory is better even than starting to swap.
> >
> > Absolutely.
>
> the mem_notify patch can realize "just before starting swapping"
> notification :)
>
> to be honest, I don't know fs guys requirement.
> if lacking feature of fs guys needed, I implement it with presure if
> you tell me it.

These notifications are really useful, but it may be much wiser to pipe them 
thru some kevent-notification sub-system, instead of introducing kernel 
notifier-chain end-points left, right, and center.


Thanks!

--
Al

