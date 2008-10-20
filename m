Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYJTUXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYJTUXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYJTUXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:23:30 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:15876 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYJTUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:23:29 -0400
X-BigFish: VPS-39(z21eWz1432R98dR936eQ1805M936fO9371P4cffizzzz23ebiz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K920MJ-02-166-01
Date: Mon, 20 Oct 2008 14:25:29 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Alok Kataria <alokkataria1@gmail.com>
CC: Antipov Dmitry <dmantipov@yandex.ru>, linux-kernel@vger.kernel.org,
       akataria@vmware.com
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Message-ID: <20081020202529.GE21041@cosmic.amd.com>
References: <673951224218937@webmail87.yandex.ru> <35f686220810171517y6632b4b2p3d251d43753eb3d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35f686220810171517y6632b4b2p3d251d43753eb3d6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 20 Oct 2008 20:23:17.0603 (UTC) FILETIME=[AFE0EB30:01C932F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/08 15:17 -0700, Alok Kataria wrote:
> On Thu, Oct 16, 2008 at 9:48 PM, Antipov Dmitry <dmantipov@yandex.ru> wrote:
> > Jordan Crouse wrote:
> >
> >> Could you try a 2.6.26 kernel? That will confirm that this is a new
> >> addition to 2.6.27.
> >
> > Both 2.6.26 and 2.6.26.6 looks good (with CONFIG_GEODE_MFGPT_TIMER=y).
> 
> Can you try the attached debug patch, it puts a printk message and
> will let us know what exaclty is failing during the calibration
> process.
> There were some major changes in the 2.6.27 cycle related to tsc calibration.
> Apart from the unification for 32 and 64bit, some checks were added in
> the code to make the calibration process more robust, maybe this
> specific machine is more prone to SMI's than other, as a result the
> checks are a little to harsh for this one.
> 
> Along with the dmesg with this patch, could you also let us know how
> much is the frequency that the (2.6.26) kernel calibrates and what the
> actual freuqency is on that box ?

I just booted with 2.6.27.1 with high res timers on, and I can't recreate
on a generic Geode box.  The only difference is that my system doesn't
have any MFGPT timers available, but that shouldn't matter if you have
CONFIG_GEODE_MFGPT_TIMER turned off.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

