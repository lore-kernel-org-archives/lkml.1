Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbZBESQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbZBESQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbZBESPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:15:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760823AbZBESPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:15:47 -0500
Date: Thu, 5 Feb 2009 19:15:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ed Swierk <eswierk@aristanetworks.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: host mmconfig detect clean up v2
Message-ID: <20090205181534.GC5661@elte.hu>
References: <1233765552.16414.6.camel@localhost.localdomain> <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com> <20090204212517.GM22608@elte.hu> <498A4DFB.7040608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A4DFB.7040608@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: not assume one place for mmconfig in nb
> 
> prepare for following case: amd fam10h + mcp55
> CPU MSR has some range, mcp55 pci config will have another one.
> 
> also prepare for mcp55 + io55 system. every one will have one range.
> 
> if it s mcp55 detect duties to execlude range that is used by CPU MSR
> aka, if CPU state bus 0-255, range in mcp55 need to be dropped.
> because HW in CPU will not route that mcp55 mmconfig to handle it.
> 
> v2: fix e7520 exit path
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> 
> ---
>  arch/x86/pci/mmconfig-shared.c |   98 ++++++++++++++++++++++-------------------
>  1 file changed, 54 insertions(+), 44 deletions(-)

looks good to me. One for the PCI tree?

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
