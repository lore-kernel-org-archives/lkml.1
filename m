Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZLVBNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZLVBNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZLVBNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:13:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbZLVBNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:13:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: BKL use in ptrace
In-Reply-To: Oleg Nesterov's message of  Monday, 21 December 2009 18:02:37 +0100 <20091221170237.GA5384@redhat.com>
References: <20091220185318.GA15989@basil.fritz.box>
	<20091221170237.GA5384@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091222011329.D78C010274@magilla.sf.frob.com>
Date: Mon, 21 Dec 2009 17:13:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I never understood this lock_kernel().
> 
> In any case it looks outdated. We were going to kill it "soon",
> along with other ptrace changes.

I never understood it either.  It's very ancient and long predates many,
many ptrace cleanups.  If the comment was ever accurate, then any issue
like that is now covered by cred_guard_mutex.  I don't know of any reason
for (or really, effect of) using BKL in ptrace.


Thanks,
Roland
