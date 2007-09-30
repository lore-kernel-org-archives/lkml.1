Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbXI3Vum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbXI3Vum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXI3Vuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:50:35 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:53001 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbXI3Vue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:50:34 -0400
From: Frans Pop <elendil@planet.nl>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Date: Sun, 30 Sep 2007 23:50:29 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <200709282225.21530.elendil@planet.nl> <20070929130234.e5f0f777.akpm@linux-foundation.org> <20070930154424.68e4218e@laptop.hypervisor.org>
In-Reply-To: <20070930154424.68e4218e@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302350.30612.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2007 21:50:32.0933 (UTC) FILETIME=[ECED6150:01C803AB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007, you wrote:
> On Sat, 29 Sep 2007 13:02:34 -0700 Andrew Morton (AM) wrote:
> AM> On Sat, 29 Sep 2007 21:40:22 +0200 Frans Pop wrote:
> AM> > 3fe6c0016fd863b233097a8219a0d8577c2fd503 is first bad commit
> AM> > commit 3fe6c0016fd863b233097a8219a0d8577c2fd503
> AM> > Author: Udo A. Steinberg <...>
> AM> >     hpet-force-enable-on-ich34
> AM> >
> AM> > Guess the comments about thin ice and testing were justified :-)
> AM> >
> AM> Great, thanks for doing that.
> AM>
> AM> I guess I'll drop the patch for now in that case.
>
> I somehow doubt that the HPET patch itself is the culprit. In fact, the
> reason it shows up on git-bisect is probably because without it HPET
> functionality is not enabled on the platform. So the problem could really
> be anywhere in the HPET-driven timer infrastructure.
>
> Frans, could you try out the -hrt patchset from Thomas Gleixner and see
> if that works? 

I'm not sure what you mean. I fetched the branch I think you referred to 
[1], but when I did a merge of that on top of v2.6.23-rc8-mm2 I 
got "Already up-to-date", so AFAICT that branch is fully merged into mm and 
I'm already running with you latest code...
Please correct me if I'm doing anything wrong.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt

> Also, what ICH does your platform have? ICH3 or ICH4?

It is ICH4.
See the link below (which I already included) for more details:
> AM> > lspci and a 2.6.23-rc6 dmesg for this system can be found in:
> AM> > http://lkml.org/lkml/2007/9/19/300

Cheers,
FJP
