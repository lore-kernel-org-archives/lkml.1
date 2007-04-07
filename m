Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXDGBV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXDGBV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 21:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXDGBVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 21:21:25 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbXDGBVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 21:21:25 -0400
Date: Fri, 6 Apr 2007 18:21:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, mingo@elte.hu
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
Message-Id: <20070406182100.9f205621.akpm@linux-foundation.org>
In-Reply-To: <20070405210316.785839431@mvista.com>
References: <20070405210316.785839431@mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 14:03:16 -0700 Daniel Walker <dwalker@mvista.com> wrote:

> Boot tested on i386, compile tested on x86_64 .. However, I couldn't
> find a !GENERIC_TIME that compiled without this change so it's untested..

I'm scratching my head over this statement.

Do you mean that none of grep -lv GENERIC_TIME arch/*/Kconfig compile?  Confused.

Oh well.  If there's a problem I'll catch it.
