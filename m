Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZIKBKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZIKBKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZIKBKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:10:45 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:45199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbZIKBKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:10:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: David Daney <ddaney@caviumnetworks.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
In-Reply-To: H. Peter Anvin's message of  Thursday, 10 September 2009 17:56:17 -0700 <4AA9A031.5000602@zytor.com>
References: <4AA991C1.1050800@caviumnetworks.com>
	<1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com>
	<4AA9A031.5000602@zytor.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090911010922.3AE9AAEF@magilla.sf.frob.com>
Date: Thu, 10 Sep 2009 18:09:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... although of course this clashes with Roland McGrath's patchset for
> the same thing which I applied earlier.  I have to say I like
> unreachable() in lower case better though...

I followed the example of existing function-like macros such as ACCESS_ONCE.
I have no preference about the name.


Thanks,
Roland
