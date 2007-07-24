Return-Path: <linux-kernel-owner+w=401wt.eu-S1763042AbXGXVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042AbXGXVDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbXGXVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:03:46 -0400
Received: from sccrmhc12.comcast.net ([63.240.77.82]:55018 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbXGXVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:03:45 -0400
Date: Tue, 24 Jul 2007 14:03:41 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] Disable lpptest on !Linux hosts
Message-ID: <20070724210341.GA530@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20070724205103.GA32043@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724205103.GA32043@plexity.net>
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24 2007, at 13:51, Deepak Saxena was caught saying:
> Even this patch isn't really the right solution b/c you really want 
> to cross-build the may be cross-building for another architecture from 
> Linux you want cross-compile, not host compile but there's no really easy

Sigh, not enough sleep. This should read:

Even this patch isn't really the right solution b/c may be cross-building 
for another architecture and you want to cross-compile this for that arch.

(Note that I "cross-compile" for x86 all the time to use a specific
 toolchain for a specific userland configuration).

~Deepak


-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net 

"Americans think their danger is terrorists. They don't understand 
the terrorists cannot take away habeas corpus, the Bill of Rights, 
the Constitution. ... The terrorists are not anything like the threat 
that we face to the Bill of Rights and the Constitution from our own
government in the name of fighting terrorisim."
  - Paul Craig Roberts
