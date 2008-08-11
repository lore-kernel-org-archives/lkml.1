Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYHKNWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYHKNWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYHKNWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:22:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48088 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYHKNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:22:30 -0400
Date: Mon, 11 Aug 2008 15:23:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: S K <nospamnoham@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811132332.GR9038@one.firstfloor.org>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <1218432270.6671.75.camel@yakui_zhao.sh.intel.com> <874p5r3jow.fsf@basil.nowhere.org> <514e099a0808110615i42ade5dctc31d87b483095e35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514e099a0808110615i42ade5dctc31d87b483095e35@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 06:15:09AM -0700, S K wrote:
> > It sounds like the BIOS just doesn't support frequency scaling.
> > Perhaps it's disabled in the BIOS setup. Or the system doesn't
> > support it at all.
> 
> It works in Windows XP, so I'm not sure if it's only a BIOS issue.

On Windows platform drivers sometimes provide a replacement DSDT
that might enable cpufreq. If that's the case there's nothing
we can do really on the Linux side. You might be able to extract
that DSDT from somewhere and supply it to Linux as a replacement
DSDT, but that's not a supported configuration in the kernel.

> If it's not that simple, then care to impart some knowledge?

If you can't get your BIOS to provide the necessary methods
then useful Linux cpufreq won't work. It's that simple.
p4-clockmod aka throttling might work, but it doesn't actually
save energy and often causes severe performance problems.

-Andi

