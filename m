Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZADJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZADJHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZADJHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:07:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZADJHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:07:13 -0500
Date: Sun, 4 Jan 2009 10:07:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: iommu build failure
Message-ID: <20090104090700.GA12938@elte.hu>
References: <alpine.LNX.1.10.0901040152430.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901040152430.5377@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> Hi,
> 
> current Linus' tree (7d3b56ba37) doesn't build for me (config can be found 
> on [1]):
> 
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `alloc_iommu': drivers/pci/dmar.c:510: undefined reference to `iommu_calculate_agaw'
> make: *** [.tmp_vmlinux1] Error 1

yep, i already reported this yesterday.

	Ingo
