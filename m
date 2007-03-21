Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbXCUVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbXCUVoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXCUVoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:44:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbXCUVoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:44:19 -0400
Date: Wed, 21 Mar 2007 14:40:52 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sky2 still broken in 2.6.20.3
Message-ID: <20070321144052.02eb2ac7@dxpl.pdx.osdl.net>
In-Reply-To: <4601950D.5000503@redhat.com>
References: <4601950D.5000503@redhat.com>
Organization: The Linux Foundation
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 16:26:53 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Transmit timeouts and locked-up adapters still occur in kernel
> 2.6.20.3.

There is more changes in 2.6.21-rc4 please try that.
I am still getting reports of timeouts with that code but
it does recover better. It may be the case that with hardware
flow control transmits can take an indefinite period so increasing
the timeout value could help.

> It looks like the patch that was applied to 2.6.20.2
> is not enough. Unfortunately that one isn't the same as what
> went upstream. Looks like it needs to be reverted, then the two
> upstream patches applied?

Until, unless the problem is reproducible with my hardware
there is not much that can be done. I'll add the better recovery
logic to for next stable cycle, but still not clear what causes
all the timeouts.
