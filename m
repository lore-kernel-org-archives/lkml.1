Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYCTKZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYCTKZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYCTKZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:25:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbYCTKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:25:37 -0400
Date: Thu, 20 Mar 2008 03:25:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
 Core Duo
Message-Id: <20080320032501.f387b3ef.akpm@linux-foundation.org>
In-Reply-To: <20080320060550.GA13200@dose.home.local>
References: <20080320060550.GA13200@dose.home.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 07:05:50 +0100 Tino Keitel <tino.keitel@gmx.de> wrote:

> Hi folks,
> 
> whereas I had working suspend with 2.6.25-rc5, I had a hang at resume
> with git HEAD from March 19th (something after 2.6.25-rc6). I tried it
> again and got another hang, so it seems to be reproducible.

Was 2.6.24 OK?

> Any hints what commit might have broke suspend? I won't have the time
> to start a git bisect or any resume debugging using CONFIG_PM_TRACE_RTC
> until next Tuesday.
> 
> This is a Mac mini Core Duo.

I assume Linus doesn't use his any more ;)

> Here is the lspci -nn output:

Please try Linus's current tree - quite a few things got reverted today
which might have fixed this.
