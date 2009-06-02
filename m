Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZFBP7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZFBP7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZFBP7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:59:32 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27438 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZFBP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:59:32 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z34a4jz1431J1432R98dR1805Mzz1202hzzz32i17ch6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKMCEP-02-QUM-01
Date: Tue, 2 Jun 2009 17:58:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: provide CPU topology information for
	multi-node processors
Message-ID: <20090602155833.GA23657@alberich.amd.com>
References: <20090529184023.GD23770@alberich.amd.com> <20090529184225.GE23770@alberich.amd.com> <36ca99e90906020805r6a4e30br6bb53aeafe5f3cd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <36ca99e90906020805r6a4e30br6bb53aeafe5f3cd7@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 02 Jun 2009 15:59:18.0806 (UTC) FILETIME=[162A0B60:01C9E39B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 05:05:07PM +0200, Bert Wesarg wrote:
> On Fri, May 29, 2009 at 20:42, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> > This support can be switched off/on using a new config option
> > MULTI_NODE_CPU. If the option is set the CPU topology information is
> > extended with cpu_node information. This includes a cpu_node_id,
> > cpu_node_siblings and cpu_node_siblings_list.

> I think this would be a step back after commit
> c50cbb05a05cf1f9ca3592272eff053c847727d8. Which exported default
> topology information, in case the architecture does not provide these
> information.

I am fine with exporting default topology information for all
architectures.

I just wanted to avoid pollution of sysfs with useless information
when this information is not provided on an architecture.

Further thoughts -- e.g. concerning the MULTI_NODE_CPU config option?

If I provide defaults for cpu_node_id, cpu_node_siblings etc. the
config option becomes rather useless and I'll remove it.


Regards,
Andreas


