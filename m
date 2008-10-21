Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJUMcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJUMcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYJUMcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:32:45 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43798 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbYJUMcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:32:45 -0400
Date: Tue, 21 Oct 2008 07:32:43 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <Yinghai.lu@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, UV: non-sparse irq based uv_setup_irq()/uv_teardown_irq() functions
Message-ID: <20081021123243.GA6408@sgi.com>
References: <20081020183718.GA22271@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020183718.GA22271@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 01:37:18PM -0500, Dean Nelson wrote:
> Provide a means for UV interrupt MMRs to be setup with the message to be sent
> when an MSI-like interrupt is raised.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> ---
> 
> Ingo,
> 
> A version of this patch, based on the sparse irq code, you applied to
> tip/x86/uv. I'm submitting this verision, which is not based on the
> sparse irq code, to replace that patch since the sparse irq code has
> been pulled from linux-next, and I'd like this functionality to get
> into linux 2.6.28.
> 
> The differences between the two patches are minimal. The bulk of it
> was to move the code that was added to io_apic.c to io_apic_64.c instead.
> I also made a small change to some of the comments.
> 
> Thanks,
> Dean
> 
>  arch/x86/kernel/Makefile     |    2 
>  arch/x86/kernel/io_apic_64.c |   67 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/uv_irq.c     |   79 +++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/uv/uv_irq.h  |   36 +++++++++++++++++
>  4 files changed, 183 insertions(+), 1 deletion(-)

It turns out that the sparse irq code and the version of this patch based
on that made it into 2.6.28, so...

please ignore this patch.
