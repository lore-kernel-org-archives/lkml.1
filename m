Return-Path: <linux-kernel-owner+w=401wt.eu-S1764785AbYBLTBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764785AbYBLTBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763397AbYBLTBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:01:33 -0500
Received: from waste.org ([66.93.16.53]:43707 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762916AbYBLTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:01:32 -0500
Subject: Re: [PATCH] Configure out DMI scanning code v2 (Linux Tiny)
From: Matt Mackall <mpm@selenic.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080212100418.5de764da@crazy>
References: <20080212100418.5de764da@crazy>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 12:56:45 -0600
Message-Id: <1202842605.12383.100.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 10:04 +0100, Thomas Petazzoni wrote:

> Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
> order to be able to remove the DMI table scanning code if it's not
> needed, and then reduce the kernel code size.
> 
> With CONFIG_DMI (i.e before) :
> 
>    text    data     bss     dec     hex filename
> 1076076  128656   98304 1303036  13e1fc vmlinux
> 
> Without CONFIG_DMI (i.e after) :
> 
>    text    data     bss     dec     hex filename
> 1068092  126308   98304 1292704  13b9a0 vmlinux
> 
> Result:
> 
>    text    data     bss     dec     hex filename
>   -7984   -2348       0  -10332   -285c vmlinux
> 
> The new option appears in "Processor type and features", only when
> CONFIG_EMBEDDED is defined.
> 
> This patch is part of the Linux Tiny project, and is based on previous
> work done by Matt Mackall <mpm@selenic.com>.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thanks for working on this.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

