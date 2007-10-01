Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbXJABNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbXJABNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 21:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXJABM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 21:12:56 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:17509 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbXJABM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 21:12:56 -0400
From: Frans Pop <elendil@planet.nl>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Date: Mon, 1 Oct 2007 03:12:51 +0200
User-Agent: KMail/1.9.7
References: <200709282225.21530.elendil@planet.nl> <200710010207.34430.elendil@planet.nl> <20071001024417.3478c2be@laptop.hypervisor.org>
In-Reply-To: <20071001024417.3478c2be@laptop.hypervisor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010312.52391.elendil@planet.nl>
X-OriginalArrivalTime: 01 Oct 2007 01:12:54.0382 (UTC) FILETIME=[31CB78E0:01C803C8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007, Udo A. Steinberg wrote:
> On Mon, 1 Oct 2007 02:07:33 +0200 Frans Pop (FP) wrote:
> FP> On Monday 01 October 2007, you wrote:
> FP> > I was suggesting to download 2.6.23-rc8 and applying the -hrt
> patchset FP> > at
> FP> >
> http://www.kernel.org/pub/linux/kernel/people/tglx/hrtimers/2.6.23-rc8/
> FP> > on top of it.
>
> FP> The system does boot with rc8 + hrt1.
>
> FP> Udo: I did see one issue during boot with this rc8 + hrt1 kernel.
> FP>      System is Debian unstable.
> FP> Setting the system clock..
> FP> select() to /dev/rtc to wait for clock tick timed out
>
> Thomas and Andrew are the best people to ask about what exactly has been
> merged from -hrt into -mm. Maybe they can chime in here.

I agree with you for the original issue.

But the /dev/rtc issue described here has *nothing* to do with mm: I saw 
that with pure Linus' 2.6.23-rc8 + Thomas' hrt1 on top: the combination you 
asked me to test.
So this is an issue in "your" hrt changes. Thomas may have some suggestions, 
but maybe you can have a look as well?

I'm of course willing to do a bisect if needed to narrow this down, but I'd 
like to know who I'll be talking or where I should follow up for issues in 
the hrt patch set.
