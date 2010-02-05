Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0BESuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:50:37 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:44769 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757273Ab0BESuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:50:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=p/qXK2I1Ngd+kyZCeNUm4VugHULCHgzYWykR/u8i9KjHa3i3f9uy0MINVjWoDlc6uuw0ZPNR+3Ctv4m9vwwsHx9NxOc+KKuBd8hCt0vkyL7mw9DrzeYfMDaDvlWAkfUK;
Date: Fri, 5 Feb 2010 10:49:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>, "Thomas Meyer" <thomas@m3y3r.de>
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes the
 screen flicker
Message-ID: <20100205104944.30200925@jbarnes-piketon>
In-Reply-To: <de962C6zBxL.A.TKG.HHiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.TKG.HHiZLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Feb 2010 01:43:12 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
> Subject		: i915: playing video via XVideo extension
> makes the screen flicker Submitter	: Thomas Meyer
> <thomas@m3y3r.de> Date		: 2009-11-23 13:15 (70 days old)
> First-Bad-Commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b42d4c5c6a872815d711e5d51a600f5122c38eee
> References	: http://lkml.org/lkml/2010/1/11/150

Just updated the bug.  Looks like we know where the problem is, just
need a couple more patches tested.

Thomas, can you check my addition and provide feedback?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
