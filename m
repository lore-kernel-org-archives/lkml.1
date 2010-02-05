Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab0BETBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:01:49 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:36875 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933721Ab0BETBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:01:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fOKJ2p2XBwmjFI7DdDKcP8vgEjFbpQ4tOVKH6Sit//anvcwC2fX+QqNgs4jZOPe1U0B8y7rPYdNfm9pTCuARkZF8jqu3T9444Lqz+DpgT3ss7taFm5x6EOWDx8Li/Pt6;
Date: Fri, 5 Feb 2010 11:01:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "tomas m" <tmezzadra@gmail.com>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Message-ID: <20100205110100.57852c31@jbarnes-piketon>
In-Reply-To: <de962C6zBxL.A.bvE.cFiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.bvE.cFiZLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Feb 2010 01:43:19 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15004
> Subject		: i915: *ERROR* Execbuf while wedged
> Submitter	: tomas m <tmezzadra@gmail.com>
> Date		: 2010-01-07 18:53 (25 days old)

Can you bisect this to a particular kernel commit?  The particular
error message means the kernel detected a GPU hang.  That's usually
a userspace bug, but the kernel should recover from it.

-- 
Jesse Barnes, Intel Open Source Technology Center
