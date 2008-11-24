Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYKXTfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYKXTfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYKXTfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:35:37 -0500
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:57051 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752057AbYKXTfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:35:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=QglSUEYMDDEd25nO+tmqYVGlLvugtpWRDZP5ZBdyg79KmJlwoxov5BQ5ixnSD7Ds3VA8fCpg0wvaapBbiuHQ953zSsU2JE9VZDSbWqlsIhgdvjQJZIhND9br+UzqUimx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: [Bug #11947] 2.6.28-rc VC switching with Intel graphics broken
Date: Mon, 24 Nov 2008 11:35:19 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Romano Giannetti (lists)" <romanol@upcomillas.es>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Mohr <andi@lisas.de>,
       devsk <kernel-bugs.dev1world@spamgourmet.com>,
       Johan Bilien <jobi@via.ecp.fr>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <200811241101.55121.jbarnes@virtuousgeek.org> <492AFCC3.4090602@birkenwald.de>
In-Reply-To: <492AFCC3.4090602@birkenwald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241135.19941.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 24, 2008 11:13 am Bernhard Schmidt wrote:
> Hello,
>
> > On Monday, November 24, 2008 12:47 am Romano Giannetti (lists) wrote:
> >> Rafael J. Wysocki wrote:
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
> >>> Subject		: 2.6.28-rc VC switching with Intel graphics broken
> >>> Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
> >>> Date		: 2008-11-03 12:10 (20 days old)
> >>> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> >>
> >> Still with us on -rc6, nasty, reproducible, no clues on what can be.
> >>
> >> VC switch locks or delay the systems minutes, resuming from suspend
> >> locks hard the machine.
> >>
> >> 2.6.28-rc is unusable here.
> >>
> >> Jesse, any hints? My suspicion that it can be the same thing happened
> >> with bug 10620 is wrong? (It was a very similar error about vblank...)
> >
> > Just added to the bug, it looks like a DUP of an issue Keith just fixed
> > last week (now to make sure the patch makes it upstream quickly).
>
> I can confirm that, with the patch from
> http://lists.freedesktop.org/archives/intel-gfx/2008-November/000614.html
> applied on top of current git head (rejected hunk in
> drivers/gpu/drm/i915/915_irq.c due to the additional
> dev_priv->irq_mask_reg = ~0; in git between the removed lines, I kept
> it) I can suspend/resume and do a VC switch again.
>
> Big thanks!

Excellent, thanks for confirming.  I just pinged the maintainer, hopefully we 
can get this patch pushed quickly.

-- 
Jesse Barnes, Intel Open Source Technology Center

