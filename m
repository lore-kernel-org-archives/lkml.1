Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab0BESwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:52:15 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:60344 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933728Ab0BESwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:52:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lkhZyP9B2s8Mobzt2RlA5szFZI54Vvka9VoV3L0ORpwkp8eYhLWzcGPO+JkbnmwmW24e/t7p5mwxOku68PhJSn08ov2oR/tsorEygRm+vhVEQ3HZ61ieCFVFCBiiENO5;
Date: Fri, 5 Feb 2010 10:51:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: davidjon@xenontk.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
Message-ID: <20100205105123.14b78a70@jbarnes-piketon>
In-Reply-To: <4B669F8F.1030402@xenontk.org>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.NbF.2FiZLB@chimera>
	<4B669F8F.1030402@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Feb 2010 15:01:59 +0530
David John <davidjon@xenontk.org> wrote:

> On 02/01/2010 06:13 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
> > Subject		: i915: Commit 0e442c60 causes flickering
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2009-12-09 17:26 (54 days old)
> > First-Bad-Commit:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> > References	:
> > http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> > Handled-By	: David John <davidjon@xenontk.org>
> > Patch		: http://patchwork.kernel.org/patch/75423/
> > 
> > 
> > 
> 
> Hi Rafael,
> 
> The patch fixing this has not been merged yet, so the bug should still
> be listed.

Eric, can you pick up David's "Disable SR when more than one pipe is
enabled" patch?  Yakui has a bigger rework of the wm code that also
fixes this problem, but it's too invasive for 2.6.33.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
