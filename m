Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbXI1UKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbXI1UKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXI1UJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:09:53 -0400
Received: from outbound-mail-49.bluehost.com ([69.89.18.18]:49627 "HELO
	outbound-mail-49.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933AbXI1UJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:09:52 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] i915: make vbl interrupts work properly on i965g/gm
Date: Fri, 28 Sep 2007 13:07:55 -0700
User-Agent: KMail/1.9.7
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0709280248480.10526@skynet.skynet.ie> <200709271909.23040.jbarnes@virtuousgeek.org> <adave9umudh.fsf@cisco.com>
In-Reply-To: <adave9umudh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281307.56037.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 28, 2007 1:02 pm Roland Dreier wrote:
> Sorry to hijack this thread, but I have a question about i915
> interrupts (945GM specifically) that I haven't gotten an answer to
> yet, and this thread reminded me of it so I thought I'd ask again:
> I hacked the kernel drm stuff on my laptop with 945GM graphics to do
> pci_enable_msi() on the graphics device, and I don't see any
> interrupts occur.
>
> So can someone with access to details of the 945GM tell me if MSI
> interrupts should work, and if so if there's some internal registers
> that need to be poked to enable it (beyond what pci_enable_msi()
> does).
>
> It's not super-urgent-- I just like using shiny things like MSI, and
> I already have ahci, iwl3945 and e1000 working with MSI on my laptop,
> so the graphics are the only thing left with an MSI capability that's
> not working.

I don't have a 945 to test with, but Dave might...

Jesse
