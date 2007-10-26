Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbXJZOap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbXJZOap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbXJZOai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:30:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXJZOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:30:37 -0400
Date: Fri, 26 Oct 2007 10:28:10 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Roland McGrath <roland@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Denys Vlasenko <vda.linux@googlemail.com>, systemtap@sources.redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20071026142810.GA14814@redhat.com>
References: <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal> <20070921133006.GF8964@redhat.com> <20070921133820.GD13129@Krystal> <20071015194120.GA22562@redhat.com> <20071015231209.GA18994@Krystal> <20071015235033.321E84D0389@magilla.localdomain> <20071025191722.GA6114@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025191722.GA6114@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Oct 25, 2007 at 03:17:22PM -0400, Mathieu Desnoyers wrote:
> [...]
> Since gcc is required to build the systemtap probes on the development
> marchine, I don't see why it would be much harder to also require prople
> to install drawf ? Or maybe the "crash" tool ?

The crash tool requires the dwarf data to work.  The dwarf data for an
entire kernel (including all the modules) is on the order of hundreds
of megabytes.  The symbol & marker list would be one thousandth the
size.  You can see the deployment attractiveness of the latter.

> I guess you must already need to extract the symbols for your kprobes.
> Do you use kallsyms for this? 

Nope.  /proc/kallsyms is a another run-time-only source of data, and
so is not applicable for off-line (ahead-of-time) mapping.

> I would rather prefer not to implement superfluous built-time data
> extraction in the kernel build system just to make userspace
> simpler. [...]

It is not superfluous, as it would solve a real distribution problem.


- FChE
