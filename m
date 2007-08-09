Return-Path: <linux-kernel-owner+w=401wt.eu-S939389AbXHINLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939389AbXHINLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934951AbXHINLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:11:30 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:31890 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934939AbXHINL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:11:29 -0400
Date: Thu, 9 Aug 2007 16:11:21 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/12] x86_64: Disable CLFLUSH support again
Message-ID: <20070809131121.GL3311@rhun.haifa.ibm.com>
References: <20070809241.425881000@suse.de> <20070809124131.B6E6114F3B@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809124131.B6E6114F3B@wotan.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 02:41:31PM +0200, Andi Kleen wrote:
> 
> It turns out CLFLUSH support is still not complete; we
> flush the wrong pages.  Again disable it for the release.
> Noticed by Jan Beulich.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Aside from the bug Jan pointed out with the patch, we're also using
cflflush in other places (arch/i386/kernel/alternative.c and
arch/x86_64/kernel/tce.c). Is the issue with clflush support specific
to pageattr.c or should it be disabled every else too? what
specifically is the issue?

Cheers,
Muli

