Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbXK0SSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbXK0SSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbXK0SS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:18:26 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45210 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757025AbXK0SS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:18:26 -0500
Date: Tue, 27 Nov 2007 10:18:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] Fix the configuration dependencies
In-Reply-To: <474BE583.2080000@mxs.nes.nec.co.jp>
Message-ID: <Pine.LNX.4.64.0711271017440.2310@schroedinger.engr.sgi.com>
References: <473CFE14.3010400@mxs.nes.nec.co.jp> <473D0170.1060304@mxs.nes.nec.co.jp>
 <20071125235843.69440d4a.akpm@linux-foundation.org> <474BE583.2080000@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Ken'ichi Ohmichi wrote:

> I guess that Christoph Lameter deleted the above part (which is added
> by the attached patch again) with the other part of discontigmem lines,
> because it depended on CONFIG_ARCH_DISCONTIGMEM_ENABLE.
> But the dependency was wrong, and it should depend on CONFIG_NUMA.
> The part is necessary for a NUMA kernel even if sparsemem.

Acked-by: Christoph Lameter <clameter@sgi.com>
