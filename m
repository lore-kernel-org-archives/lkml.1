Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXFZWd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXFZWd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbXFZWdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:33:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:51814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbXFZWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:33:52 -0400
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Cc: "Shaohua Li" <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	<1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
	<6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Jun 2007 01:29:35 +0200
In-Reply-To: <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>
Message-ID: <p731wfy5m74.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel J Blueman" <daniel.blueman@gmail.com> writes:

> On 23/03/07, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Thu, 2007-03-22 at 23:45 +0000, Daniel J Blueman wrote:
> > > Hi Shao-hua,
> > >
> > > Is the tool you mentioned last June [1] available for splitting up the
> > > old firmware files to the new format (eg
> > > /lib/firmware/intel-ucode/06-0d-06), or are updates available from
> > > Intel (or otherwise) in this new format?
> > Yes, we are preparing the new format data files and maybe put it into a
> > new website. We will announce it when it's ready.
> 
> It's been a while; is there any sign of the ucode updates being
> available, especially in light of the C2D/Q incorrect TLB invalidation
> + recent ucode to fix this?

That microcode update is not needed on any recent Linux kernel; it flushes
the TLBs in a way that is fine.

-Andi
