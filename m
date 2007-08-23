Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXHWIVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXHWIVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 04:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXHWIV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 04:21:26 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:36364 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXHWIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 04:21:25 -0400
Subject: Re: [PATCH] Reset current->pdeath_signal on SUID binary execution
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
In-Reply-To: <1187380078.6698.448.camel@violet>
References: <1187380078.6698.448.camel@violet>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 10:21:11 +0200
Message-Id: <1187857271.15402.20.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> the attached patch fixes a flaw in the "parent process death signal"
> when executing SUID binaries. An unprivileged user may send arbitrary
> signal to a child process even if it is running with higher privileges.
> 
> The idea to fix this issue is to reset pdeath_signal not only on fork,
> but also on the execution of a SUID binary.
> 
> Michael, if we fix it this way, then the prctl() manual page should
> reflect that behavior.

the patch has been merged into 2.4 and 2.6, so the manual page needs an
update at some point.

> From comments it seems that we have to also reset pdeath_signal inside
> LSM when it comes to capability-raised executes, but I must admit that I
> got lost there.

No further comments for this one? I am not familiar enough with it.

Regards

Marcel


