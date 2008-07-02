Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbYGBCPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbYGBCPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbYGBCPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:15:22 -0400
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:50047 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757731AbYGBCPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:15:22 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Generic per-device coherent dma allocator
Date: Tue, 1 Jul 2008 19:15:08 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080629101846.GA23362@doriath.ww600.siemens.net> <20080630105835.GA27466@elte.hu>
In-Reply-To: <20080630105835.GA27466@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011915.08540.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2008 3:58 am Ingo Molnar wrote:
> * Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > Currently x86_32, sh and cris-v32 provide per-device coherent dma
> > memory allocator. However their implementation is nearly identical.
> > Refactor out common code to be reused by them.
>
> looks good to me in principle.
>
> Andrew, Jesse: i've put this aside into the core/generic-dma-coherent
> git tree which you can check at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> core/generic-dma-coherent
>
> there's some interaction with other x86 bits so i guess it would be best
> to carry this in -tip.
>
> Do the generic bits look good to you? (find the shortlog and diff below)
> It's not yet propagated into linux-next, pending your ack/nak and
> pending some test exposure.

Yeah, looks great to me; if you have dependent changes you can push it; I 
don't think I have anything in my tree that'll cause real trouble.

Jesse
