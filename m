Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149Ab0AHIDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0AHIDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987Ab0AHID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:03:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48137
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab0AHID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:03:28 -0500
Date: Fri, 08 Jan 2010 00:03:37 -0800 (PST)
Message-Id: <20100108.000337.255400791.davem@davemloft.net>
To: jslaby@suse.cz
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] SPARC: use helpers for rlimits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1262791479-26594-5-git-send-email-jslaby@suse.cz>
References: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
	<1262791479-26594-5-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Wed,  6 Jan 2010 16:24:33 +0100

> Make sure compiler won't do weird things with limits. E.g. fetching
> them twice may return 2 different values after writable limits are
> implemented.
> 
> I.e. either use rlimit helpers added in
> 3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
> or ACCESS_ONCE if not applicable.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied, thanks Jiri.
